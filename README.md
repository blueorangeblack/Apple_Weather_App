# Apple Weather App
> Apple Weather App Clone Project
<br>

## 개발 목표
1. OpenWeather API를 사용하여 Apple Weather App과 비슷하게 만들기
2. CollectionView Compositional Layout사용하기
3. SwiftLint 이외에 다른 외부 라이브러리 사용하지 않기
<br>

## Demo
| 날씨 정보 보기 <br> - (현재 위치 사용을 허용할 경우) 나의 위치와 추가한 도시들의 날씨 정보를 볼 수 있음 |
| :--------------- |
| <img src = "https://user-images.githubusercontent.com/81162435/156112597-f407fd4e-eb1f-4949-8ef9-ee12119eea71.gif" width = "270"> <img src = "https://user-images.githubusercontent.com/81162435/156112781-8d592b85-57f2-4c22-976c-3643cfb779e7.gif" width = "270"> |
| 도시 검색, 추가, 편집, 삭제 <br> - 원하는 도시를 검색하여 목록에 추가, 삭제, 순서 변경을 할 수 있고 앱 종료 후 다시 실행해도 목록을 순서대로 표시함 |
| <img src = "https://user-images.githubusercontent.com/81162435/156113037-fd692bf3-5381-44fa-bb1f-ea1a8cd32d7f.gif" width = "270"> <img src = "https://user-images.githubusercontent.com/81162435/156114035-d5a86518-81e5-47c2-b9cc-0211062ae136.gif" width = "270"> |
| 지도 보기 <br> - (현재 위치 사용을 허용할 경우) 나의 위치와 추가한 도시들의 현재 기온이 지도에 표시됨 |
| <img src = "https://user-images.githubusercontent.com/81162435/156115768-339e0ab3-85dc-4843-9746-b1ddf32229ef.gif" width = "270"> |
| 온도 단위 변환 <br> - 섭씨 또는 화씨로 설정할 수 있고, 설정시 앱 전체에 적용되며 앱 종료 후 다시 실행해도 설정한 단위가 적용됨 |
| <img src = "https://user-images.githubusercontent.com/81162435/156116665-290b74fc-3aeb-4158-9992-7089faa11e9e.gif" width = "270"> |
<br>

## 설계 및 기능
### 1. MainViewController
- 날씨 정보 (현재 날씨, 시간별 일기예보, 8일간의 일기예보, 날씨 세부 정보)
<img width="856" src="https://user-images.githubusercontent.com/81162435/155971042-e0bcbf05-f2e3-47e4-97de-b38aa875dd2f.png">

### 2. CityWeatherListViewController
- 추가한 도시 목록 보기 & 도시 검색 & 편집 & 삭제
<img width="856" src="https://user-images.githubusercontent.com/81162435/155969796-e66f10c8-513a-4b2c-83bc-8f5aec3937fa.png">
<img width="856" src="https://user-images.githubusercontent.com/81162435/155969929-d8c7ed43-b89d-4d7b-a50f-634be4f1c1b8.png">

- 온도 단위 변환
<img width="856" src="https://user-images.githubusercontent.com/81162435/155987958-0e18159d-d0ff-4d52-8825-2e3793aa884e.png">

### 3. MapViewController
- 지도 보기
<img width="856" src="https://user-images.githubusercontent.com/81162435/155988819-f63cd9e7-a815-4815-9eb4-fa39355fda3c.png">
<br>
