import matplotlib.pyplot as plt
import numpy as np

i=1
j=2
maxi=0
maxj=0
x=[]
y=[]
sum1_0=[0,0,0,0,0]
sum1_49=[0,0,0,0,0]
sum1_99=[0,0,0,0,0]
sum2=[]
sum3=[]
sum4=[]
sum5=[]
sorted_array=[0,0,0,0,0]
tput_median=[]
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

path="E:\\open_loop\\effects_of_different_interval\\100_ms"
#path="E:\effect of durable log\without durable"
nclient=20
filename=".\\scripts\\different_interval\\ol_latency_100_ms.txt"





for x in range(1, nclient):

    i=0
    myfile = open(path+"\\run1\\logs1\\logs1\\client-"+str(x)+".tputlat.txt")

    for line in myfile:
        line.strip()
        #print(line)
        tput=line.split("\t")
        #print(sum1_0[0])

        try: 
            #print(str(x)+":"+str(tput[3]))
            sum1_0[0]=sum1_0[0]+float(tput[1])
            sum1_49[0]=sum1_49[0]+float(tput[3])
            sum1_99[0]=sum1_99[0]+float(tput[8])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        break
    # plotting the points 
    myfile.close() 

sum1_0[0]=sum1_0[0]/nclient
sum1_49[0]=sum1_49[0]/nclient
sum1_99[0]=sum1_99[0]/nclient

for x in range(1, nclient):

    i=0
    myfile = open(path+"\\run2\\logs1\\logs1\\client-"+str(x)+".tputlat.txt")

    for line in myfile:
        line.strip()
        #print(line)
        tput=line.split("\t")
        #print(sum1_0[0])

        try: 
            #print(str(x)+":"+str(tput[3]))
            sum1_0[1]=sum1_0[1]+float(tput[1])
            sum1_49[1]=sum1_49[1]+float(tput[3])
            sum1_99[1]=sum1_99[1]+float(tput[8])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        break
    # plotting the points 
    myfile.close() 

sum1_0[1]=sum1_0[1]/nclient
sum1_49[1]=sum1_49[1]/nclient
sum1_99[1]=sum1_99[1]/nclient


for x in range(1, nclient):

    i=0
    myfile = open(path+"\\run1\\logs1\\logs1\\client-"+str(x)+".tputlat.txt")

    for line in myfile:
        line.strip()
        #print(line)
        tput=line.split("\t")
        #print(sum1_0[0])

        try: 
            #print(str(x)+":"+str(tput[3]))
            sum1_0[2]=sum1_0[2]+float(tput[1])
            sum1_49[2]=sum1_49[2]+float(tput[3])
            sum1_99[2]=sum1_99[2]+float(tput[8])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        break
    # plotting the points 
    myfile.close() 

sum1_0[2]=sum1_0[2]/nclient
sum1_49[2]=sum1_49[2]/nclient
sum1_99[2]=sum1_99[2]/nclient



for x in range(1, nclient):

    i=0
    myfile = open(path+"\\run1\\logs1\\logs1\\client-"+str(x)+".tputlat.txt")

    for line in myfile:
        line.strip()
        #print(line)
        tput=line.split("\t")
        #print(sum1_0[0])

        try: 
            #print(str(x)+":"+str(tput[3]))
            sum1_0[3]=sum1_0[3]+float(tput[1])
            sum1_49[3]=sum1_49[3]+float(tput[3])
            sum1_99[3]=sum1_99[3]+float(tput[8])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        break
    # plotting the points 
    myfile.close() 

sum1_0[3]=sum1_0[3]/nclient
sum1_49[3]=sum1_49[3]/nclient
sum1_99[3]=sum1_99[3]/nclient


for x in range(1, nclient):

    i=0
    myfile = open(path+"\\run1\\logs1\\logs1\\client-"+str(x)+".tputlat.txt")

    for line in myfile:
        line.strip()
        #print(line)
        tput=line.split("\t")
        #print(sum1_0[0])

        try: 
            #print(str(x)+":"+str(tput[3]))
            sum1_0[4]=sum1_0[4]+float(tput[1])
            sum1_49[4]=sum1_49[4]+float(tput[3])
            sum1_99[4]=sum1_99[4]+float(tput[8])
    


        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        break
    # plotting the points 
    myfile.close() 

sum1_0[4]=sum1_0[4]/nclient
sum1_49[4]=sum1_49[4]/nclient
sum1_99[4]=sum1_99[4]/nclient



myfile = open(filename,"w")


sum1_0.sort()
sum1_49.sort()
sum1_99.sort()

print(sum1_0)
print(sum1_49)
print(sum1_99)


myfile.write(str(sum1_0[2])+"\t"+str(sum1_49[2])+"\t"+str(sum1_99[2]))
#myfile.write(str((sum1[x]+sum2[x]+sum3[x])/3)+"\n")
#myfile.write(str(sorted_array[3])+"\n")
                     
myfile.close()



