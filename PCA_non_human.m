clc
close all
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_images=190;
tau_neutral=zeros([num_images*193 162]);
A_neutral=zeros([num_images 193*162]);
for i=1:num_images
    tau_neutral(i:i+192,:)=imread(strcat(num2str(i),'a.jpg'));
    A_neutral(i,:)=reshape(tau_neutral(i:i+192,:),1,193*162);
end
mean_face_neutral=sum(A_neutral)/num_images;
phi_neutral=(A_neutral-mean_face_neutral)';

files={'geisel.jpg','porsche.jpg'};

for file=files
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    car=imread(char(file));
    car=double(car(:,:,1));
    car=imresize(car,[193,162]);
    CAR=car;
    car=reshape(car,193*162,1);
    car=car-mean_face_neutral';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    remove_pca=[0];
    j=1;
    i=0;
    [eig_vec_ata,eig_val_ata]=eig(phi_neutral'*phi_neutral);
    
    u=phi_neutral*eig_vec_ata(:,i+1:end);          %As eigenvalues are in increasing order, pick last K eigenvectors
    u=normc(u);
    w=u'*car;
    phi_cap=w'*u';
    faces=phi_cap+mean_face_neutral;
    rec_face=reshape(faces(j,:),[193 162]);
    h=figure;
    subplot(1,2,2)
    imagesc(rec_face)
    colormap gray
    title('Recovered Object')
    subplot(1,2,1)
    imagesc(CAR)
    colormap gray
    title('Original Object')
    sgtitle(['For no. of PC=',num2str(190-i)])
    saveas(h,[pwd '/Results/E',num2str(190-i),'_',char(file)],'tiffn')
end