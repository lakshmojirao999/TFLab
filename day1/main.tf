provider "local" {
  
}

resource "local_file" "file1" {
    content = "Day1 Terraform Class"
    filename = "hello.txt"
    file_permission = "0644"
  
}

resource "local_file" "file2" {
    content = "Day1 Terraform Class"
    filename = "hello2.txt"
    file_permission = "0644"
  
}
