function plot_10(x,fb,fs)
% 绘制序列x的前10个码元波形
for i = 1:10  
    plot(((i-1)/fb:1/fs:i/fb-1/fs),x((i-1)*fs/fb+1:i*fs/fb)); hold on
end