%np-CSMA协议程序????? 
function [Traffic,S,Delay]=aloha(capture) 
%ALOHA 此处显示有关此函数的摘要
%   此处显示详细说明

%   输入参数
%   capture:是否考虑捕获效应 0：不考虑 1：考虑

%   输出参数
%   Traffic：实际产生的业务量
%   S：吞吐量
%   Dela：平均延迟

 
%定义终端状态常数以及仿真结果参数
STANDBY = 0; %等待                                 
TRANSMIT = 1; %传输
COLLISION = 2; %碰撞      
TOTAL=10000; %成功传输多少数据包后仿真结束   
 
% 定义信道参数
brate = 6e6; %比特速率                       
Srate = 0.25e6; %符号速率                        
Plen = 500; %包长（符号数）                              
Ttime = Plen / Srate; %每个数据包的传输时间                         
Dtime = 0.1; %归一化传播时延   
delay = Dtime * Ttime;
alfa  = 3; %路径损耗指数                                    
sigma = 6; %阴影衰落标准差[dB] 
 
%定义接入点信息
r = 100; %服务区域半径                                 
bxy = [0, 0, 5]; %接入点位置坐标 (x,y,z)[m]                               
tcn = 10; %接入点进行正确信号解调所需的最低符号功率[dBm] 
 

 
Mnum  = 100;                                  
mcn   = 30;                                   
mpow  = 10^(mcn/10) * sqrt(r^2+bxy(3)^2)^alfa;   
h=0;                                           
mxy = [randsrc(2,Mnum,[-r:r]); randsrc(1,Mnum,[0:h])]; 
while 1 
    d=sqrt(sum(mxy(1:2,:).^2));                    
    [tmp,indx]=find(d>r); 
    if length(indx) == 0                                 
        break 
    end 
    mxy(:,indx)=[randsrc(2,length(indx),[-r:r]);mxy(3,indx)];  
end 
distance=sqrt(sum(((ones(Mnum,1)*bxy).'-mxy).^2)); 
mrnd = randn(1,Mnum);                           
 
% G=[0.1:0.1:1,2:10,20:20:40];                 ?? 
G=[0.1:0.1:1,2:10,20];    
for indx=1:length(G) 
 
    %初始化相关参数，依据Possion分布
    Tint  = -Ttime / log(1-G(indx)/Mnum); %数据包产生间隔的期望值    
    Rint  = Tint; %数据包重传间隔的期望值                             
    Spnum = 0; %成功传输的包个数                               
    Splen = 0; %成功传输的符号个数                             
    Tplen = 0; %带传输的符号数                               
    Wtime = 0; %传输延迟时间[z]                              
     
    mgtime        = -Tint * log(1-rand(1,Mnum));  
    Mstime        = zeros(1,Mnum) - inf;            
    mtime         = mgtime;                         
    Mstate        = zeros(1,Mnum);                  
    Mplen(1:Mnum) = Plen;                          
    now_time     = min(mtime);    
 
  
    while 1 
         
        idx = find(mtime==now_time & Mstate==TRANSMIT);   
         
        if length(idx) > 0 
            Spnum       = Spnum + 1; 
            Splen       = Splen + Mplen(idx); 
            Wtime       = Wtime + now_time - mgtime(idx); 
            Mstate(idx) = STANDBY; 
            mgtime(idx) = now_time - Tint * log(1-rand);   
            mtime(idx)  = mgtime(idx);                      
        end 
         
        idx = find(mtime==now_time & Mstate==COLLISION);    
        if length(idx) > 0 
            Mstate(idx) = STANDBY; 
            mtime(idx)  = now_time - Rint * log(1-rand(1,length(idx))); 
        end 
    
       idx = find(mtime==now_time & Mstate==STANDBY);                        
       if length(idx) > 0 
        Tplen = Tplen + sum(Mplen(idx)); 
            for ii=1:length(idx) 
                jj = idx(ii); 
               
                idx1 = find((Mstime+delay)<=now_time & now_time<=(Mstime+delay+Ttime));  
                if length(idx1) == 0                      
                    Mstate(jj) = TRANSMIT;                   
                    Mstime(jj) = now_time;                      
                    mtime(jj)  = now_time + Mplen(jj) / Srate;
                else                                            
                    mtime(jj) = now_time - Rint * log(1-rand); 
                end 
            end 
        end 
         
        if Spnum >= TOTAL                              
            break 
        end 
         
        idx = find(Mstate==TRANSMIT | Mstate==COLLISION);   
        if capture == 0                                  
            if length(idx) > 1 
                Mstate(idx) = COLLISION;                  
            end 
        else                                            
            if length(idx) > 1 
                dxy  = distance(idx);                      
                pow  = mpow * dxy.^-alfa .* 10.^(sigma/10*mrnd(idx));   
                [maxp no] = max(pow); 
                if Mstate(idx(no)) == TRANSMIT 
                    if length(idx) == 1 
                        cn = 10 * log10(maxp); 
                    else 
                        cn = 10 * log10(maxp/(sum(pow)-maxp+1)); 
                    end 
                    Mstate(idx) = COLLISION; 
                    if cn >= tcn                         
                        Mstate(idx(no)) = TRANSMIT;        
                    end 
                else 
                    Mstate(idx) = COLLISION; 
                end 
            end 
        end 
        now_time = min(mtime);                          
    end 
     
    Traffic(indx) = Tplen / Srate / now_time; %计算实际产生的业务量    
    T=Traffic(indx) 
    S(indx) = Splen/Srate/now_time; %计算吞吐量   
    Delay(indx) = Wtime / TOTAL * Srate / Plen; %计算平均延迟           
 
end 
 
%end


