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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau_smile=zeros([num_images*193 162]);
A_smile=zeros([num_images 193*162]);
for i=1:num_images
    tau_smile(i:i+192,:)=imread(strcat(num2str(i),'b.jpg'));
    A_smile(i,:)=reshape(tau_smile(i:i+192,:),1,193*162);
end
mean_face_smile=sum(A_smile)/num_images;
phi_smile=(A_smile-mean_face_smile)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

remove_pca=[0,10,20,50,100];

[eig_vec_ata,eig_val_ata]=eig(phi_neutral'*phi_neutral);
for j=1:1
for i=remove_pca
    u=phi_neutral*eig_vec_ata(:,i+1:end);          %As eigenvalues are in increasing order, pick last K eigenvectors
    u=normc(u);
    w=u'*phi_smile;
    phi_cap=w'*u';
    faces=phi_cap+mean_face_neutral;
    rec_face=reshape(faces(j,:),[193 162]);
    h=figure;
    subplot(1,2,2)
    imagesc(rec_face)
    colormap gray
    title('Recovered Face')
    subplot(1,2,1)
    imagesc(double(imread(strcat(num2str(j),'b.jpg'))))
    colormap gray
    title('Original Face')
    sgtitle(['For no. of PC=',num2str(190-i)])
    saveas(h,[pwd '/Results/C',num2str(190-i),'_Img',num2str(j)],'tiffn')
end
end