# TestMarketApp

**Приложение содержит четыре экрана :** 
 * **Экран категорий** содержит экран актуальных категорий кухни, текущее местоположение пользователя (Город), а так же текущее время в требуемом формате.
 * **Экран блюд** содержит список доступных блюд выбранной категории (был дан api только одной категории). Так же возможность сортировки блюд по типам. 
 * **Экран выбранного блюда** вызывается по нажатию на блюдо поверх экрана блюд, содержит информацию о нем, возможность добавить в корзину.
 * **Экран корзины** содержит список блюд, добавленных в корзину, возможность изменить количество.
 
## Preview
![Screen](https://github.com/GregoryDushin/TestMarketApp/blob/main/TestApp.png?raw=true)

## Tecnologies

* UIKit
* MVVM design pattern
* RxSwift
* CoreLocation
* RealmSwift
* Alamofire
* Multithreading with GCD
* Networking with URLSession
* UITableView and UICollectionView

## Resources
### Networking
* [Category](https://run.mocky.io/v3/058729bd-1402-4578-88de-265481fd7d54) | [Dishes](https://run.mocky.io/v3/aba7ecaa-0a70-453b-b62d-0e326c859b3b)
### Design
* [Figma](https://www.figma.com/file/fSVhgQTluvoqkAa6ZnpQQO/%D0%A2%D0%B5%D1%81%D1%82%D0%BE%D0%B2%D0%BE%D0%B5-%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5_ios?type=design&node-id=0%3A1&mode=design&t=i8rS3cLLnEqkBIgg-1) 

## Requirements
* iOS 13.0+
* Xcode 13.0+

## Installation
1. Fork and clone this project to your machine
2. Open the `.xcodeproj` file in Xcode
3. Change the Build identifier
4. Build and run
