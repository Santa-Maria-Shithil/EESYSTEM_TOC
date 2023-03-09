import matplotlib.pyplot as plt
import numpy as np

i=1
j=2
maxi=0
maxj=0
x=[]
y=[]
sum1=[]
sum2=[]
sum3=[]
sum4=[]
sum5=[]
sorted_array=[0,0,0,0,0]
tput_median=[]
for x in range(0,1000):
    sum1.append(0.0)
    sum2.append(0.0)
    sum3.append(0.0)
    sum4.append(0.0)
    sum5.append(0.0)
#x.append(0)
#x.append(1)
#y.append(0.0)
#y.append(200.0)

b=[]
#b.append(0.0)
#b.append(200.0)

c=[]
#c.append(0.0)
#c.append(200.0)


d=[]
#d.append(0.0)
#d.append(200.0)


e=[]
#e.append(0.0)
#e.append(200.0)

path="E:\\open_loop\\effects_of_conflict\\0_conflict_with_rps"
#path="E:\effect of durable log\without durable"
nclient=15
filename=".\\scripts\\ol_tput_zero_conflict_rps"



for x in range(1, nclient):

    i=0
    myfile = open(path+"\\run1\logs1\logs1\client-"+str(x)+".throughput.txt")

    for line in myfile:
        line.strip()
        #print(line)
        tput=line.split("\t")
         

        try: 
            #print(str(x)+":"+str(tput[3]))
            sum1[i]=sum1[i]+float(tput[3])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        i=i+1
    # plotting the points 
    myfile.close() 



for x in range(1, nclient):
    i=0
    myfile = open(path+"\\run2\logs1\logs1\client-"+str(x)+".throughput.txt")
    for line in myfile:
        line.strip()
        print(line)
        tput=line.split("\t")
         

        try: 
            #print(str(x)+":"+str(tput[3]))
            sum2[i]=sum2[i]+float(tput[3])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        i=i+1
    # plotting the points 
    myfile.close() 


for x in range(1, nclient):
    i=0
    myfile = open(path+"\\run3\logs1\logs1\client-"+str(x)+".throughput.txt")
    for line in myfile:
        line.strip()
        #print(line)
        tput=line.split("\t")
         

        try: 
            #print(str(x)+":"+str(tput[3]))
            sum3[i]=sum3[i]+float(tput[3])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        i=i+1
    # plotting the points 
    myfile.close() 
#print(sum3)

for x in range(1, nclient):
    i=0
    myfile = open(path+"\\run4\logs1\logs1\client-"+str(x)+".throughput.txt")
    for line in myfile:
        line.strip()
        #print(line)
        tput=line.split("\t")
         

        try: 
           # print(str(x)+":"+str(tput[3]))
            sum4[i]=sum4[i]+float(tput[3])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        i=i+1
    # plotting the points 
    myfile.close() 

#print(sum4)


for x in range(1, nclient):
    i=0
    myfile = open(path+"\\run5\logs1\logs1\client-"+str(x)+".throughput.txt")
    for line in myfile:
        line.strip()
       # print(line)
        tput=line.split("\t")
         

        try: 
           # print(str(x)+":"+str(tput[3]))
            sum5[i]=sum5[i]+float(tput[3])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        i=i+1
    # plotting the points 
    myfile.close() 
#print(sum5)



myfile = open(filename,"w")

for x in range(0,1000):
    sorted_array[0]=sum1[x]
    sorted_array[1]=sum2[x]
    sorted_array[2]=sum3[x]
    sorted_array[3]=sum4[x]
    sorted_array[4]=sum5[x]
    
    sorted_array.sort()
    
    print(sorted_array)

    myfile.write(str((sum1[x]+sum2[x]+sum3[x]+sum4[x]+sum5[x])/5)+"\n")
    #myfile.write(str((sum1[x]+sum2[x]+sum3[x])/3)+"\n")
    #myfile.write(str(sorted_array[3])+"\n")
                     
myfile.close()



