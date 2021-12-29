# output "broker_private_ip" {
#   value       = data.aws_instance.edge_broker.*.private_ip
#   description = "The Private IP address of the edge instances in the Wavelength Zone"
# }

# output "broker_carrier_ip" {
#   value       = data.aws_instance.edge_broker.*.carrier_ip
#   description = "The Carrier IP address of the edge instances in the Wavelength Zone"
# }

# output "subnets" {
#   value = [for subnet in aws_subnet.region_subnets: subnet.id]
# }