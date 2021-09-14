# private-sql-instance-and-connecting-to-it-using-bastion-host
Here, I have created one private sql instance on Google Cloud and then connected to that via a bastion host.


Once you have successfully deployed private sql instance. Now, you could connect to it via cloud proxy or bastion Host. 

I used bastion host to connect. 

So, you basically need to create a VM in the same VPC as that of your sql instance. SSH to that ( I wasn't able to initially due to some firewall issue. Then I created a firewall rule allowing SSH and tcp on port 22 and applied that network tag on my VM. Hence, I was able to ssh to that. )

One more thing, I choose custom mode VPC, hence I had to create one subnet under that VPC in order to create VM in that VPC.

Once you are into that VM, you need to install sql-client. 

      $sudo apt-get update
      $sudo apt-get install \
    default-mysql-server
    
    $mysql --host=[INSTANCE_IP_ADDR] \
    --user=root --password
    
    
    
One more thing, in background this private instance using concept of vpc peering. So, it will create internal VPC peering. Peered VPC network are generally named as servicenetworking. We could find this in VPC Network Peering section. 
