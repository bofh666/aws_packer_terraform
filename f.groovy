job('objective-f') {
    scm {
        github('bofh666/aws_packer_terraform')
    }
    steps {
        shell('make')
    }
}
