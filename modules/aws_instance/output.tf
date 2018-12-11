# outputs produced at the end of a terraform apply: id of base route table
output "aws_instance_id" {
  value = "${aws_instance.instance.*.id}"
}

output "aws_instance_private_ip" {
  value = "${aws_instance.instance.*.private_ip}"
}

output "aws_instance_public_ip" {
  value = "${aws_instance.instance.*.public_ip}"
}
