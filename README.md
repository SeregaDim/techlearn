# TechLearn

Обучающее приложение на Flutter. Бургер-меню с главными разделами, на главном экране горизонтальная лента подтем выбранного раздела, по нажатию открывается статья. Весь контент лежит в JSON-файлах, код менять не нужно.

## Запуск

```bash
cd techlearn
flutter create . --project-name techlearn --org com.example   # один раз: создаст android/ios/web/...
flutter pub get
flutter run
```

`flutter create .` не трогает существующие `lib/`, `pubspec.yaml` и `test/`. Он только добавляет недостающие платформенные папки.

Нужен Flutter 3.22 или новее.

## Структура

```
assets/
├── images/hero.png          # (необязательно) картинка в баннере, например робот из макета
└── content/
    ├── categories.json      # главные разделы = пункты бургер-меню
    ├── linux/               # одна папка на раздел
    │   ├── ubuntu.json      # один файл = одна тема (кнопка в ленте + статья)
    │   ├── debian.json
    │   ├── arch.json
    │   ├── bash-commands.json
    │   └── bash-scripts.json
    ├── backend/  frontend/  git/  code/  databases/  devops/
docs/topic_template.json     # шаблон новой темы
lib/
├── main.dart, app.dart, config.dart
├── models/content.dart              # Category, Topic, ContentBlock
├── services/content_repository.dart # чтение JSON из assets
├── state/app_state.dart             # тема, раздел, прогресс (shared_preferences)
├── theme/app_theme.dart             # светлая и тёмная палитры
├── utils/icon_map.dart              # имя иконки из JSON -> Icons.*
├── screens/home_screen.dart, article_screen.dart
└── widgets/                         # шапка, меню, лента, карточки, блоки статьи
```

## Как добавить тему

1. Скопируйте `docs/topic_template.json` в папку раздела, например `assets/content/linux/fedora.json`.
2. Заполните `title`, `subtitle`, `icon`, `order` и `blocks`.
3. Перезапустите приложение (hot restart). Кнопка появится в ленте сама. Список файлов определяется автоматически.

`order` задаёт позицию в ленте (меньше = левее). Без `order` тема уходит в конец и сортируется по названию.

## Как добавить раздел

1. Создайте папку `assets/content/<папка>/` и положите туда хотя бы один JSON.
2. Добавьте раздел в `assets/content/categories.json`:
   ```json
   { "id": "security", "title": "Безопасность", "subtitle": "Основы защиты", "folder": "security", "icon": "shield" }
   ```
3. Добавьте папку в `pubspec.yaml` в список `assets:` (одна строка `- assets/content/security/`). Flutter сам не заходит в подпапки, поэтому это нужно сделать один раз на раздел.
4. `flutter pub get` и перезапуск.

## Формат темы

```json
{
  "id": "fedora",
  "title": "Fedora",
  "subtitle": "Короткое описание под заголовком",
  "icon": "inventory",
  "order": 6,
  "blocks": [
    { "type": "heading",   "text": "Заголовок" },
    { "type": "paragraph", "text": "Текст. Можно `встроенный код` в обратных кавычках." },
    { "type": "list",      "items": ["пункт 1", "пункт 2"] },
    { "type": "steps",     "items": ["шаг 1", "шаг 2"] },
    { "type": "code",      "language": "bash", "text": "sudo dnf install git" },
    { "type": "note",      "kind": "tip", "text": "kind: tip | warning | info" }
  ]
}
```

Иконки задаются именем из `lib/utils/icon_map.dart`. Нужной нет, добавьте строку в карту.

## Дизайн

Киберпанк-тема из макета: тёмный синий фон, неоновое свечение, переключатель солнце/луна в шапке и в меню. Цвета лежат в `lib/theme/app_theme.dart` (`TechColors.dark` и `TechColors.light`). Выбранная тема и пройденные статьи сохраняются на устройстве.

Имя пользователя и бейдж Pro в меню настраиваются в `lib/config.dart`.
