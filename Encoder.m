clear;
clc;

cover=imread('D:\nimsale avale 96-97\thesis\ASLI\implementation\Watermark in Medicine\Cover6.bmp');
cover=im2double(cover);

watermark=rgb2gray(imread('D:\nimsale avale 96-97\thesis\ASLI\implementation\Watermark in Medicine\Watermark2.bmp'));
watermark=im2double(watermark);
[LL1 HL1 LH1 HH1]=dwt2(cover,'haar');
dct_LH1=dct2(LH1);
[uc,sc,vc] = svd(dct_LH1);

pass=20;
[m n]=size(watermark);
xxx=zeros(m);
n=n-1;
for i=1:pass
for y=0:n
for x=0:n
p=[1 1;1 2]*[x;y];
xxx(mod(p(2),m)+1,mod(p(1),m)+1)=watermark(y+1,x+1);
end
end
watermark=xxx;
end
watermark_enc=xxx;
dct_w=dct2(watermark_enc);
[uw,sw,vw] = svd(dct_w);

k=0.015;
swat=sc+(k*sw);

dct_LH1_wat=uc*swat*vc';
LH1_wat=idct2(dct_LH1_wat);

watermarked=idwt2(LL1,HL1,LH1_wat,HH1,'haar');

%=====================================================

[LL1 HL1 LH1 HH1]=dwt2(watermarked,'haar');
[LL2 HL2 LH2 HH2]=dwt2(LL1,'haar');

info=uint8('Lump is observed.');
counts=[1:128];
code=arithenco(info,counts);

mlen=length(info);
clen=length(code);
bit_mlen=dec2bin(mlen,8)-'0';
bit_clen=dec2bin(clen,8)-'0';
k=0.06;

[sx sy]=size(LL2);

x=1;
y=1;

for i=1:8
LL2(x,y)=(LL2(x,y))*(1+(k*bit_mlen(i)));
x=x+1;
if x>sx
x=1;
y=y+1;
end
end

for i=1:8
LL2(x,y)=(LL2(x,y))*(1+(k*bit_clen(i)));
x=x+1;
if x>sx
x=1;
y=y+1;
end
end

for i=1:clen
LL2(x,y)=(LL2(x,y))*(1+(k*code(i)));
x=x+1;
if x>sx
x=1;
y=y+1;
end
end

LL1=idwt2(LL2,HL2,LH2,HH2,'haar');
watermarked=idwt2(LL1,HL1,LH1,HH1,'haar');

%=====================================================

[LL1 HL1 LH1 HH1]=dwt2(watermarked,'haar');
[LL2 HL2 LH2 HH2]=dwt2(LL1,'haar');
[LL3 HL3 LH3 HH3]=dwt2(LL2,'haar');

info2=uint8('BXBPS4999S1');
counts2=[1:128];
code2=arithenco(info2,counts2);

mlen2=length(info2);
clen2=length(code2);
bit_mlen2=dec2bin(mlen2,8)-'0';
bit_clen2=dec2bin(clen2,8)-'0';
k=0.06;

[sx sy]=size(LL3);

x=1;
y=50;

for i=1:8
LL3(x,y)=(LL3(x,y))*(1+(k*bit_mlen2(i)));
x=x+1;
if x>sx
x=1;
y=y+1;
end
end

for i=1:8
LL3(x,y)=(LL3(x,y))*(1+(k*bit_clen2(i)));
x=x+1;
if x>sx
x=1;
y=y+1;
end
end

for i=1:clen2
LL3(x,y)=(LL3(x,y))*(1+(k*code2(i)));
x=x+1;
if x>sx
x=1;
y=y+1;
end
end

LL2=idwt2(LL3,HL3,LH3,HH3,'haar');
LL1=idwt2(LL2,HL2,LH2,HH2,'haar');
watermarked=idwt2(LL1,HL1,LH1,HH1,'haar');
imshow(watermarked);
imwrite(watermarked,'D:\nimsale avale 96-97\thesis\ASLI\implementation\Watermark in Medicine\Watermarked.jpg');
ssim1=ssim(watermarked,cover)%without attck on watermarked image
Attack_watermarked7=imnoise(watermarked,'poisson');
Attack_watermarked8=imnoise(watermarked,'speckle',0.004);
%***********************************************************************
%%with attack
Attack_watermarked1=imnoise(watermarked,'gaussian',0,0.00001);
ssim2=ssim(Attack_watermarked1,cover)
Attack_watermarked2=imnoise(watermarked,'salt & pepper',0.001);
ssim3=ssim(Attack_watermarked2,cover)
Attack_watermarked3=imrotate(watermarked,0.0005);
Attack_watermarked3=imresize(Attack_watermarked3,[512,512]);
ssim4=ssim(Attack_watermarked3,cover)
Attack_watermarked4=medfilt2(watermarked,[2 2]);
ssim5=ssim(Attack_watermarked4,cover)
Attack_watermarked5=imcrop(watermarked,[2 2 256 256]);
ssim6=ssim(Attack_watermarked8,cover)
Attack_watermarked6=imread('D:\nimsale avale 96-97\thesis\ASLI\implementation\Watermark in Medicine\Watermarked.jpg');
Attack_watermarked6=double(Attack_watermarked6);
ssim7=ssim(Attack_watermarked7,cover)
