function runexamples(ncase)
% runexamples(ncase) runs eight different test examples for the
% polyhedron program 

ns=@(x,ndig)num2str(x,ndig); nd=8; Ns=@(x)num2str(x);
switch ncase
    case 1
titl='TRIANGULAR BLOCK WITH A HOLE'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xtb,ytb,ztb,idftb]=triablock; 
[v,rc,vrr,irr]=polhedrn(xtb,ytb,ztb,idftb); r=rc';
disp(' '), disp(['Volume = ',ns(v,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xtb,ytb,ztb,idftb,360,180,[0 0 1],[0,2,0],titl,[1 1 0])

    case 2 
titl='HEXAPOD'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xhp,yhp,zhp,idfhp]=hexapod;
[v,rc,vrr,irr]=polhedrn(xhp,yhp,zhp,idfhp); r=rc';
disp(' '), disp(['Volume = ',ns(v,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xhp,yhp,zhp,idfhp,180,90,[0 0 1],[0,0,0],titl,[1 1 0])

    case 3
titl='REGULAR OCTAHEDRON WITH EDGE LENGTH = 1'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xoh,yoh,zoh,idfoh]=octahedron;
[v,rc,vrr,irr]=polhedrn(xoh,yoh,zoh,idfoh); r=rc';
disp(' '), disp(['Volume = ',ns(v,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(r)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xoh,yoh,zoh,idfoh,180,90,[0 0 1],[0 0 0],titl,[1 1 0])

    case 4
titl='REGULAR ICOSAHEDRON OF UNIT VOLUME'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xih,yih,zih,idfih]=icosahedron;
[v,rc,vrr,irr]=polhedrn(xih,yih,zih,idfih); r=rc';
[dumy,k]=max(zih); eln=2*yih(k);
disp(' '), disp(['Volume = ',ns(v,nd),',   EDGE LENGTH = ',ns(eln,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xih,yih,zih,idfih,180,90,[0 0 1],[0 0 0],titl,[1 1 0])

    case 5
titl='REGULAR DODECAHEDRON OF UNIT VOLUME'; disp(' ')
disp(['THE SOLID IS A ',titl])
[xdh,ydh,zdh,idfdh]=dodecahedron;
[dumy,k]=max(zdh); eln=2*ydh(k);
[v,rc,vrr,irr]=polhedrn(xdh,ydh,zdh,idfdh); r=rc'; 
disp(' '), disp(['Volume = ',ns(v,nd),',   EDGE LENGTH = ',ns(eln,nd)]); 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]);
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)) 
rph(xdh,ydh,zdh,idfdh,180,90,[0 0 1],[0 0 0],titl,[1 1 0])

    case 6
rbot=1; rtop=.5; zbot=-.5; ztop=.5; ncirc=50;         
titl=['FRUSTUM USING ',num2str(ncirc),' SIDE ELEMENTS']; disp(' ')
disp(['THE SOLID IS A ',titl]) 
[v,vr,vrr,irr,ve,vre,vrre,irre,xcf,ycf,zcf]=...
    frustum(rbot,rtop,zbot,ztop,ncirc); 
rc=vr(:)'/v; rce=vre'/ve; drc=rc-rce; dv=v-ve; dirr=irr-irre;
disp(' '), disp(['Volume = ',ns(v,nd)]); disp(' ')
disp(['Volume-VolumeExact = ',Ns(dv)]) 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]); disp(' ')
disp(['norm(CentroidalRadius-CentroidalRadiusExact) = ',...
Ns(norm(drc))])
disp(' '), disp('Inertia Tensor ='), disp(ns(irr,nd)),disp(' ')
disp(['norm(InertiaTensor-InertiaTensorExact) =',Ns(norm(dirr))])  
rph(xcf,ycf,zcf,0,360,180,[1 0 0],[0 0 0],titl,[1 1 0])

    case 7
nlon=50; nlat=25;        
titl=['SPHERE USING ',num2str(nlon*nlat),' SURFACE ELEMENTS'];
disp(' '), disp(['THE SOLID IS A ',titl])
[v,vr,vrr,irr,ve,vre,vrre,irre,xsp,ysp,zsp]=sphrprop(nlon,nlat); 
rc=vr'/v; rce=vre'/ve; drc=rc-rce; dv=v-ve;
disp(' '), disp(['Volume = ',ns(v,nd)]); disp(' ')
disp(['Volume-VolumeExact = ',Ns(dv)]) 
disp(' '), disp(['Centroidal Radius = ',dispv(rc)]); disp(' ')
disp(['norm(CentroidalRadius-CentroidalRadiusExact) = ',...
Ns(norm(drc))])
disp(' '), disp('Inertia Tensor ='), disp(Ns(irr))
dirr=irr-irre; disp(' ') 
disp(['norm(InertiaTensor-InertiaTensorExact) =',Ns(norm(dirr))]) 
rph(xsp,ysp,zsp,0,180,90,[1 0 0],[0 0 1],titl,[1 1 0])

    case 8
%a=2; b=1; nlat=80; nlon=160;        
a=2; b=1; nlat=40; nlon=nlat*ceil(1+a/b);        
titl=['TORUS USING ',Ns(nlat*nlon),' SURFACE ELEMENTS'];
disp(' '), disp(['THE SOLID IS A ',titl])
[v,vr,vrr,irr,ve,vre,vrre,irre,xto,yto,zto]=torusprop(a,b,nlat,nlon);
rc=vr'/v; rce=vre'/ve; drc=rc-rce; disp(' '), dv=v-ve;
disp(['Volume             = ',Ns(v)]), disp(' ')
disp(['Volume-VolumeExact = ',Ns(dv)]), disp(' ')
%disp(['Centroidal Radius = [',Ns(rc),']']); disp(' ')
disp(['Centroidal Radius = ',dispv(rc)]); disp(' ')
disp(['norm(CentroidalRadius-CentroidalRadiusExact) = ',...
Ns(norm(drc))])
disp(' '), disp('Inertia Tensor ='), disp(Ns(irr))
dirr=irr-irre; disp(' ') 
disp(['norm(InertiaTensor-InertiaTensorExact) =',Ns(norm(dirr))]) 
rph(xto,yto,zto,0,180,90,[1 0 0],[0 0 1],titl,[1 1 0])

    case 9
clc, explain  

    otherwise
disp('Invalid case number'), return
end %switch case