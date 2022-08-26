### Define Output
output "vpc_id" {
  description = "The vpc id"
  value       = aws_vpc.this.id
}

output "public_subnet" {
  value = [
    for subnet in aws_subnet.public:
    subnet.id
  ]
}

output "private_subnet" {
  value = [
    for subnet in aws_subnet.private:
    subnet.id
  ]
}

output "nat_gateway" {
  value = [
    for nat in aws_nat_gateway.public:
    { 
      "eip": "${nat.allocation_id}",
      "id": "${nat.id}",
      "subnet": "${nat.subnet_id}"
    }
  ]
}

output "internet_gateway" {
  value = aws_internet_gateway.this.id
}

output "nat_ips" {
  value = [
    for eip in aws_eip.this:
    { 
      "id": "${eip.id}" 
      "ip": "${eip.public_ip}"
    }
  ]
}