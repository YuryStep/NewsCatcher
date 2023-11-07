# NewsCatcher
**Поиск новостных статей по ключевым словам по всему миру и вывод результатов в ленту**. 

По тапу открывается полный текст статьи. Появляется возможность перейти к оригинальному источнику или сохранить статью, чтобы вернуться к ней позже в соответствующем разделе.
Вы можете выбрать страну и язык публикации, а также места поиска ключевых слов (заголовки, описание, основной текст).

## Стэк, Ограничения и Архитектура
Стэк: **Swift 5, UIKit, WebKit**  
Минимальная версия: **iOS 15**   
Архитектура: **MVP**   

<table>
 <tr>
 <td align="center"><img src="https://i.imgur.com/EfRSnWS.png" width="350"></td>
 <td align="center"><img src="https://i.imgur.com/SzgqjMn.png" width="350"></td>
 <td align="center"><img src="https://i.imgur.com/2t2OUM9.png" width="350"></td>
 <td align="center"><img src="https://i.imgur.com/fJ6gfcl.png" width="350"></td>
 </tr>
</table>

###### Примечания
* *В связи с ограничениями API, приложение отображает только 10 релевантных статей. Полный текст статьи также ограничен, но его можно прочитать в оригинальном источнике.*

* *Если выбранный язык новостей, не является официальным в стране поиска, скорее всего, вы не найдете соответствующих публикаций. В таком случае измените одно из ограничений на "Any".*

## Особенности проекта
* Проект написан на **`UIKit`** без использования сторонних фреймворков
* Использована архитектура **`MVP`**
* Верстка выполнена кодом **`без использования storyboard`**
* Используется **`UITableView + DataSource`** c кастомными ячейками
* Используется **`UICollectionView + DiffableDataSource`**
* Динамическое изменение количества ячеек в ответ на действия пользователя (SettingsView)
* Взаимодействие с сетью реализовано с использованием **`URLSession`**
* Работа с многопоточностью, с использованием **`GCD`**
* Кэширование изображений реализовано с использованием **`NSCache`**
* Сохранение статей происходит в **`UserDefaults`**
* Для обработки ошибок используется класс **`Result`**
 * В случае отсутствия internet или превышения количества запросов - показывается Alert
 * Если статьи по запросу не найдены - отображается полноэкранное "No Articles Found"
* Если новость опубликована сегодня, вместо даты отображается "Today" **`DateFormatter`**
* Использована **`кастомная UIButton`** c анимацией нажатия
* Реализована возможность выбора критериев поиска
* Цвета собраны в отдельном **`Asset Catalog`**
* Сборка вынесена в отдельный слой NewsCatcherAssembly
* Для сохранения чистоты кода в проекте использованы **`Swiftlint`** и **`SwiftFormat`**

## Какой еще планируется реализовать функционал
* Добавить поддержку темной темы
* Добавить локализацию

## Что еще планируется реализовать технически
* Заменить способ работы с многопоточностью с GCD на **`Async await`**
* Изменить хранение статей с UserDefaults на **`CoreData`**  
*В этом проекте использованием CoreData - это излишнее усложнение, рассматриваемое только в учебных целях.*




