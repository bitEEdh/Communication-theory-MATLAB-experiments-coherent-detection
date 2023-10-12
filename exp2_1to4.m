% 解答实验二的（1）～（4）
close all
sb = randsrc(1,100,[-1,1]);     % 产生长为100的随机二进制序列
fb = 1e3;                       % 码元速率
fc = 10*fb;                     % 载波频率
fc2 = 10.05*fb;
phi = pi/4;                     % 载波初相
fs = 100*2*fc;                  % 波形采样率
t = 0:1/fs:100/fb-1/fs; lt = length(t);  % 100个码元序列的时间向量
xc = cos(2*pi*fc*t+phi);        % 原始载波
xc2 = cos(2*pi*fc2*t+phi);
xm = zeros(1,lt);               % 已调信号
for i = 1:100                  % BPSK调制
    if sb(i) == -1
        xm((i-1)*fs/fb+1:i*fs/fb) = -cos(2*pi*fc*((i-1)/fb:1/fs:i/fb-1/fs)+phi);
    else
        xm((i-1)*fs/fb+1:i*fs/fb) = cos(2*pi*fc*((i-1)/fb:1/fs:i/fb-1/fs)+phi);
    end
end
figure; plot_10(xm,fb,fs);   % 绘制前10个码元波形
[pxx,f] = periodogram(xm,hamming(lt),[],fs);
figure; plot(f,10*log10(pxx))  % 绘制功率谱
xlabel('频率/Hz')
ylabel('功率谱密度/(dBW/Hz)')

x = xm.*xc;                % 已调信号乘以相干载波
figure; plot_10(x,fb,fs)   % 绘制x(t)前10个码元波形
h1 = ones(1,100); h2 = ones(1,120);
y1 = conv(x(1:10*fs/fb),h1); y2 = conv(x(1:10*fs/fb),h2); % 分别用两种低通滤波器滤波
ly1 = length(y1); ly2 = length(y2);
n1 = (0:ly1+(ly1+1)/10-1)/(ly1+(ly1+1)/10-1)*11; n2 = (0:ly2+(ly2+1)/10-1)/(ly2+(ly2+1)/10-1)*11;
z1 = zeros(1,ly1+1); z2 = zeros(1,ly2+1);
for i = 1:2:19      % 对低通滤波结果进行抽样判决
    if y1((ly1+1)/10/2*i)>=0
        z1(1+(ly1+1)/10/2*(i-1):(ly1+1)/10/2*(i+1)) = ones(1,(ly1+1)/10);
    elseif y1((ly1+1)/10/2)<0
        z1(1+(ly1+1)/10/2*(i-1):(ly1+1)/10/2*(i+1)) = -ones(1,(ly1+1)/10);
    end
    if y2((ly2+1)/10/2*i)>=0
        z2(1+(ly2+1)/10/2*(i-1):(ly2+1)/10/2*(i+1)) = ones(1,(ly2+1)/10);
    elseif y2((ly2+1)/10/2)<0
        z2(1+(ly2+1)/10/2*(i-1):(ly2+1)/10/2*(i+1)) = -ones(1,(ly2+1)/10);
    end
end
figure
subplot(221)
plot(n1(1:ly1),y1,'r')
xlabel('码元序号'); title('第一种低通滤波器的输出波形y(t)')
subplot(223)
plot(n1((ly1+1)/10/2:ly1+(ly1+1)/10/2),z1,'g')
title('第一种低通滤波器抽样判决输出序列')
subplot(222)
plot(n2(1:ly2),y2,'r');
xlabel('码元序号'); title('第二种低通滤波器的输出波形y(t)')
subplot(224)
plot(n2((ly2+1)/10/2:ly2+(ly2+1)/10/2),z2,'g')
title('第二种低通滤波器抽样判决输出序列');



