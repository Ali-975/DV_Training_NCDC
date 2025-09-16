main:
jal ra,boot
jal ra, multiply
jal x0, exit
boot:
jalr x0,ra,0
multiply:
jalr x0,ra,0
exit:
