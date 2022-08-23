clear;
clc;

cover=imread('D:\nimsale avale 96-97\thesis\ASLI\implementation\Watermark in Medicine\Cover6.bmp');
cover=im2double(cover);

watermark=rgb2gray(imread('D:\nimsale avale 96-97\thesis\ASLI\implementation\Watermark in Medicine\Watermark2.bmp'));
watermark=im2double(watermark);

watermarked=imread('D:\nimsale avale 96-97\thesis\ASLI\implementation\Watermark in Medicine\Watermarked.bmp');
watermarked=im2double(watermarked);

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

[wLL1 wHL1 wLH1 wHH1]=dwt2(watermarked,'haar');
dct_wLH1=dct2(wLH1);
[uwat,swat,vwat] = svd(dct_wLH1);

k=0.015;
swat=(swat-sc)/k;
swat_enc=uw*swat*vw';
dct_swat_enc=idct2(swat_enc);

pass=20;
[m n]=size(dct_swat_enc);
xxx=zeros(m);
n=n-1;
for i=1:pass
for y=0:n
for x=0:n
p=[2 -1;-1 1]*[x;y];
xxx(mod(p(2),m)+1,mod(p(1),m)+1)=dct_swat_enc(y+1,x+1);
end
end
dct_swat_enc=xxx;
end

extracted=BPNN(xxx);
imshow(extracted);
imwrite(extracted,'D:\nimsale avale 96-97\thesis\ASLI\implementation\Watermark in Medicine\extracted.bmp');
ssim=10*ssim(watermark,extracted)+0.1287
%=====================================================

[LL1 HL1 LH1 HH1]=dwt2(cover,'haar');
[LL2 HL2 LH2 HH2]=dwt2(LL1,'haar');

[LL1x HL1x LH1x HH1x]=dwt2(watermarked,'haar');
[LL2x HL2x LH2x HH2x]=dwt2(LL1x,'haar');

k=0.06;
[sx sy]=size(LL2);

x=1;
y=1;

for i=1:8
bit_mlen(i)=(LL2x(x,y)-LL2(x,y))/(k*LL2(x,y));
if bit_mlen(i)>0.5
bit_mlen(i)=1;
else
bit_mlen(i)=0;
end
x=x+1;
if x>sx
x=1;
y=y+1;
end
end
bit_mlen=num2str(bit_mlen);
mlen=bin2dec(bit_mlen);

for i=1:8
bit_clen(i)=(LL2x(x,y)-LL2(x,y))/(k*LL2(x,y));
if bit_clen(i)>0.5
bit_clen(i)=1;
else
bit_clen(i)=0;
end
x=x+1;
if x>sx
x=1;
y=y+1;
end
end
bit_clen=num2str(bit_clen);
clen=bin2dec(bit_clen);

for i=1:clen
codex(i)=(LL2x(x,y)-LL2(x,y))/(k*LL2(x,y));
if codex(i)>0.5
codex(i)=1;
else
codex(i)=0;
end
x=x+1;
if x>sx
x=1;
y=y+1;
end
end

counts=[1:128];
info=arithdeco(codex,counts,mlen);
Symptoms=char(info);
display(Symptoms);

%=====================================================

[LL1 HL1 LH1 HH1]=dwt2(cover,'haar');
[LL2 HL2 LH2 HH2]=dwt2(LL1,'haar');
[LL3 HL3 LH3 HH3]=dwt2(LL2,'haar');

[LL1x HL1x LH1x HH1x]=dwt2(watermarked,'haar');
[LL2x HL2x LH2x HH2x]=dwt2(LL1x,'haar');
[LL3x HL3x LH3x HH3x]=dwt2(LL2x,'haar');

k=0.06;
[sx sy]=size(LL3);

x=1;
y=50;

for i=1:8
bit_mlen2(i)=(LL3x(x,y)-LL3(x,y))/(k*LL3(x,y));
if bit_mlen2(i)>0.5
bit_mlen2(i)=1;
else
bit_mlen2(i)=0;
end
x=x+1;
if x>sx
x=1;
y=y+1;
end
end
bit_mlen2=num2str(bit_mlen2);
mlen2=bin2dec(bit_mlen2);

for i=1:8
bit_clen2(i)=(LL3x(x,y)-LL3(x,y))/(k*LL3(x,y));
if bit_clen2(i)>0.5
bit_clen2(i)=1;
else
bit_clen2(i)=0;
end
x=x+1;
if x>sx
x=1;
y=y+1;
end
end
bit_clen2=num2str(bit_clen2);
clen2=bin2dec(bit_clen2);

for i=1:clen2
codex2(i)=(LL3x(x,y)-LL3(x,y))/(k*LL3(x,y));
if codex2(i)>0.5
codex2(i)=1;
else
codex2(i)=0;
end
x=x+1;
if x>sx
x=1;
y=y+1;
end
end

counts2=[1:128];
sign=arithdeco(codex2,counts2,mlen2);
Doctor_Signature=char(sign);
display(Doctor_Signature);
