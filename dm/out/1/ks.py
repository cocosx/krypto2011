import csv

csvReader = csv.reader(open('score_sorted.csv', 'rb'), delimiter=';')
csvReader.next()
#data=[]
Fg={}
Fb={}
Ng=0
Nb=0
for row in csvReader:
    #data.append(row)
    if int(row[0])==1:
        Nb+=1
        Fb[float(row[3])]=Nb/402.0
    else:
        Ng+=1
        Fg[float(row[3])]=Ng/14751.0


Bkeys=Fb.keys()
Bkeys.sort()
for k in Bkeys:
    print("{0},{1}".format(k,Fb[k]))

Gkeys=Fg.keys()
Gkeys.sort()
for k in Gkeys:
    print("{0},{1}".format(k,Fg[k]))


a=Gkeys[0]
Cg=Fg[Gkeys[0]]
ig=0
Cb=Fb[Bkeys[0]]
ib=0
m=0;
while a<200:
    print('a', a)
    if m<abs(Fb[Bkeys[ib]]-Fg[Gkeys[ig]]):
        m=abs(Fb[Bkeys[ib]]-Fg[Gkeys[ig]])         
    a+=0.1
    if Bkeys[ib+1]<a:
        print('ib', ib)
        ib+=1
    if Gkeys[ig+1]<a:
        print('ig', ig)
        ig+=1
print(m)
