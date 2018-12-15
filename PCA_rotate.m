clc
close all
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_images=190;
tau_neutral=zeros([num_images*193 162]);
A_neutral=zeros([num_images 193*162]);
for i=1:190
    tau_neutral(i:i+192,:)=imread(strcat(num2str(i),'a.jpg'));
    A_neutral(i,:)=reshape(tau_neutral(i:i+192,:),1,193*162);
end
mean_face_neutral=sum(A_neutral)/num_images;
phi_neutral=(A_neutral-mean_face_neutral)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

remove_pca=[0];
angle_set=0:45:315;

[eig_vec_ata,eig_val_ata]=eig(phi_neutral'*phi_neutral);
for angle=angle_set
    for i=remove_pca
        neutral_face=imread('15a.jpg');
        neutral_face=double(neutral_face(:,:,1));
        neutral_face=imrotate(neutral_face,angle);
        neutral_face=imresize(neutral_face,[193,162]);
        rotated_face=neutral_face;
        neutral_face=reshape(neutral_face,193*162,1);
        neutral_face=neutral_face-mean_face_neutral';
        u=phi_neutral*eig_vec_ata(:,i+1:end);          %As eigenvalues are in increasing order, pick last K eigenvectors
        u=normc(u);
        w=u'*neutral_face;
        phi_cap=w'*u';
        faces=phi_cap+mean_face_neutral;
        rec_face=reshape(faces(1,:),[193 162]);
        h=figure;
        subplot(1,2,2)
        imagesc(rec_face)
        colormap gray
        title('Recovered Face')
        subplot(1,2,1)
        imagesc(rotated_face)
        colormap gray
        title('Rotated Face')
        sgtitle(['Rotation angle=',num2str(angle)])
        saveas(h,[pwd '/Results/F',num2str(190-i),'_angle',num2str(angle)],'tiffn')
    end
end