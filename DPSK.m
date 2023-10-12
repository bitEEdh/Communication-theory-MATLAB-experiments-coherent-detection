% 解答实验二（5）
close all; clear
sb = randsrc(1, 100, [0, 1]); % 绝对码
fb = 1e3; % 码元速率
fc = 10 * fb; % 载波频率
phi = pi / 4; % 载波初相
fs = 100 * 2 * fc; % 采样率
t = 0:1 / fs:101 / fb - 1 / fs;
lt = length(t); % 相对码的时间向量
xm = zeros(1, lt);
sbr = zeros(1, 101); % 相对码
sbr(2) = xor(sb(1), 0);
for i = 3:101 % 用传号差分规则构造相对码
    sbr(i) = xor(sb(i-1), sbr(i-1));
end
for i = 1:101 % 用相对码进行绝对调相，产生DPSK信号
    if sbr(i) == 1
        xm((i - 1)*fs/fb+1:i*fs/fb) = -cos(2*pi*fc*((i - 1) / fb:1 / fs:i / fb - 1 / fs)+phi);
    else
        xm((i - 1)*fs/fb+1:i*fs/fb) = cos(2*pi*fc*((i - 1) / fb:1 / fs:i / fb - 1 / fs)+phi);
    end
end
Wp = [fc - fb, fc + fb] / (fs / 2);
Ws = [fc - 4 * fb, fc + 4 * fb] / (fs / 2);
Rp = 3;
Rs = 30;
[n, Wn] = buttord(Wp, Ws, Rp, Rs);
[b, a] = butter(n, Wn); % 构造带通滤波器
xa = filter(b, a, xm); % 对DPSK信号带通滤波
la = length((1:11 * fs / fb)); % 前11个码元的向量长度
figure
subplot(221)
plot(t(1:11/fb*fs), xa(1:la));
xlabel('时间/s');
title('a点波形')
subplot(222)
plot(t(1+1/fb*fs:12/fb*fs), xa(1:la));
xlabel('时间/s');
title('b点波形')
xc = xa(1+1/fb*fs:11/fb*fs) .* xa(1:10/fb*fs); % 延时后波形和原波形相乘
subplot(223)
plot(t(1+1/fb*fs:11/fb*fs), xc);
xlabel('时间/s');
title('c点波形')
h = ones(1, 100);
xd = conv(xc, h);
ld = length(xd); % 低通滤波
subplot(224)
plot(t(1+1/fb*fs:1/fb*fs+ld), xd);
xlabel('时间/s');
title('d点波形')
