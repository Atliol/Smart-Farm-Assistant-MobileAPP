from pathlib import Path
p = Path(r'd:\game\Smart-Farm-Assistant-MobileAPP\uni_project\lib\screens\news\services\push_notification_service.dart')
lines = p.read_text(encoding='utf-8').splitlines()
for i in range(248, 256):
    print(i+1, repr(lines[i]))
