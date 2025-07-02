#!/bin/bash

# تغيير موجه التيرمنال للمستخدم العادي
echo -e '\n# Set PS1 to light blue' >> ~/.bashrc
echo 'export PS1="\e[1;94m\$\e[0m "' >> ~/.bashrc

# تطبيق التغييرات
source ~/.bashrc

# التأكد من وجود الملف للروت
if [ -f /root/.bashrc ]; then
    echo -e '\n# Set PS1 to light red for root' | sudo tee -a /root/.bashrc > /dev/null
    echo 'export PS1="\e[1;91m\$\e[0m "' | sudo tee -a /root/.bashrc > /dev/null
else
    echo "⚠️ ملف /root/.bashrc غير موجود، سيتم إنشاؤه..."
    echo '# Set PS1 to light red for root' | sudo tee /root/.bashrc > /dev/null
    echo 'export PS1="\e[1;91m\$\e[0m "' | sudo tee -a /root/.bashrc > /dev/null
fi

echo "✅ تم تعيين الألوان:"
echo "- المستخدم العادي: أزرق فاتح"
echo "- الروت: أحمر فاتح"