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

[eig_vec_ata,eig_val_ata]=eig(phi_neutral'*phi_neutral);
u=phi_neutral*eig_vec_ata(:,0+1:end);          %As eigenvalues are in increasing order, pick last K eigenvectors
u=normc(u);
eigenface_set=[1:3,188:190];

for eigenface=eigenface_set
eig_face=u(:,eigenface);
eig_face=reshape(eig_face,193,162);
    h=figure;
    imagesc(eig_face)
    colormap gray
    title(['Eigenface for Image',num2str(eigenface)])
    saveas(h,[pwd '/Results/A_Eigenface',num2str(eigenface)],'tiffn')
end