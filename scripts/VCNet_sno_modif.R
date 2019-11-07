#---------------------------------------
# Aim: perform VCNet analysis-----------
# Author: Zengmiao WANG-----------------
# Date: Aug 13, 2016--------------------
# Contact: wangzengmiao@gmail.com-------
#---------------------------------------
# libraries to be loaded----------------
library(CompQuadForm);
library(survey);
#--------useful function----------------
abstract_exp = function(name1,exp){
	N = dim(exp)[2];
	X1 = exp[which(exp[,1]==name1),3:N];
	return(t(X1));
}

VCNet =	function(gene1,gene2){
	N = dim(gene1)[1];
	p = dim(gene1)[2];
	q = dim(gene2)[2];
	Cor = cor(gene1,gene2);
	Cor1 = cor(gene1);
	Cor2 = cor(gene2);
	lambda1 = eigen(Cor1,only.values=T)$values;
	lambda2 = eigen(Cor2,only.values=T)$values;
	Lamda = rep(lambda1,each=q)*lambda2;
	Index = which(abs(Lamda)<1e-08);
	if(length(Index)>0){
		Lamda[which(abs(Lamda)<1e-08)] = 0;
	}

	TranC = 3;
	TransCor = log((1+Cor*sqrt(TranC)/2)/(1-Cor*sqrt(TranC)/2))/sqrt(TranC);
	TransFnorm = (N-2.5)*sum(TransCor^2);
	results = davies(q=TransFnorm,lambda=Lamda,lim=1000000);
	if(results$ifault==0 | results$ifault==2){
		if(results$Qq>=0){
			p.value_TransFnorm = results$Qq;
		}else{
			p.value_TransFnorm = pchisqsum(x=TransFnorm, df=rep(1,length(Lamda)), a=Lamda, lower.tail = FALSE,method='saddlepoint');
		}
	}else{
		p.value_TransFnorm = pchisqsum(x=TransFnorm, df=rep(1,length(Lamda)), a=Lamda, lower.tail = FALSE,method='saddlepoint');
	}
	return(data.frame(TransFnorm=TransFnorm,p.value_TransFnorm=p.value_TransFnorm));
}


#---------------------------------------

#Resultfile: this is the name of the output file with ".txt" extension.
#Datafile: this is the name of the input file with ".txt" extension.

# ADDED other_file IN THE FUNCTION AND CHANGED sno_file
PerformVCNet = function(sno_file,other_file,Resultfile){

	Exp	= read.table(other_file,header=T,sep="\t");
	Exp[,c(1,2)] = as.character(as.matrix(Exp[,c(1,2)]));
	# N = dim(Exp)[2]-2;
	Var = apply(Exp[,3:dim(Exp)[2]],1,var);
	Exp = Exp[which(Var>0),]
	gene  = unique(Exp[,1]);
	result = data.frame();

	# ADDED BLOCK ! CHANGED
	sno_exp	= read.table(sno_file,header=T,sep="\t");
	sno_exp[,c(1,2)] = as.character(as.matrix(sno_exp[,c(1,2)]));
	# N = dim(sno_exp)[2]-2;
	sno_Var = apply(sno_exp[,3:dim(sno_exp)[2]],1,var);
	sno_exp = sno_exp[which(sno_Var>0),]
	sno_gene  = unique(sno_exp[,1]);

	for(i in 1:(length(sno_gene))){
		for(j in 1:length(gene)){
			if(sno_gene[i] == gene[j]){
				break
			}
			X1 = abstract_exp(sno_gene[i],sno_exp);
			X2 = abstract_exp(gene[j],Exp);
			result = rbind(result,data.frame(gene1=sno_gene[i],gene2=gene[j],VCNet(X1,X2)));
		}
	}
	write.table(result,file=Resultfile,sep="\t",quote=F,row.names=F,col.names=T);
}
