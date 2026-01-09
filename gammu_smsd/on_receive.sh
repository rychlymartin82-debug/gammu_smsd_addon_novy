cat > on_receive.sh << 'EOF'
#!/bin/bash
echo "SMS received: FROM=$SMS_1_NUMBER MESSAGE=$SMS_1_TEXT"
EOF

chmod +x on_receive.sh
