## <img src="https://github.com/user-attachments/assets/2296d53a-cd74-4e38-8d4a-4f84072cbecb" width=24> 토덕 To.duck - 성인 ADHD 환자를 위한 토닥임

<img width="77" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/iOS-16.0+-silver"> <img width="83" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/Xcode-16.4-blue"> <img width="77" alt="Swift 5.0" src="https://img.shields.io/badge/Swift-5.0+-orange">

### <img src="https://github.com/user-attachments/assets/506a2403-2af4-4dd2-a3b0-82cfb7aaf7ed" width=19> 토덕 주요 기능
> [데모 영상 보러가기](https://kyxxn.notion.site/To-duck-2049adb326268030a845f97960593442?source=copy_link)

| ![1페이지_ 홈 - 하루를 한눈에](https://github.com/user-attachments/assets/b5de4323-00ea-4807-b334-00442b9c5147) | ![2페이지_ 홈 - 일정 관리의 모든 것](https://github.com/user-attachments/assets/45414f5b-1a87-479a-a35c-6b277791524b) | ![3페이지_ 집중 - 혼자 혹은 함께하는 집중 모드](https://github.com/user-attachments/assets/36d90813-c8bd-47fc-983d-01f1132ff1e8) |
|:-:|:-:|:-:|
| ![4페이지_ 일기 - 감정과 성과를 기록](https://github.com/user-attachments/assets/206a95ff-c4d7-44b1-83bf-a5d54e2f3fec) | ![5페이지_ 일기 - 감정과 성과를 기록-1](https://github.com/user-attachments/assets/a651fc7b-b3b7-4273-8456-098dc9652449) | ![6페이지_ 일기 - 감정과 성과를 기록-2](https://github.com/user-attachments/assets/105d3810-7b03-4187-bce4-9b531c318fa0) |

##

### 🧱 아키텍처

> ### Butterfly Architecture + MVVM + Coordinator


<div align="center">

  <img width="980" alt="스크린샷 2024-11-28 오후 11 04 05" src="https://github.com/user-attachments/assets/9520b8ab-a61b-43a4-9a58-b7cbfd1a5687">

</div>

- UI와 로직을 분리하고 화면 단위의 책임을 명확히 하기 위해 **MVVM 패턴과 Coordinator 패턴을 함께 적용**

- 복잡한 **비즈니스 로직을 UseCase 단위로 분리**하고, 테스트 용이성과 유지보수성을 높이기 위해 **Domain Layer**를 도입

- 외부 의존성과의 결합도를 낮추기 위해 **Repository Pattern을 적용하고**,  
  서버 통신과 로컬 저장의 책임을 분리하기 위해 **TDNetwork 모듈과 TDStorage 모듈을 각각 구성**


##

### 🧑‍💻 팀원소개

| <img src="https://avatars.githubusercontent.com/u/129862357?s=400&u=b25bda6955bd46dcef49161230ca633947169589&v=4" width="80"/> | <img src="https://avatars.githubusercontent.com/u/46300191?v=4" width="80"/> |
| :---: | :---: |
| 박효준 | 손승재 |
| [@Kyxxn](https://github.com/Kyxxn) | [@Sonny-Kor](https://github.com/Sonny-Kor) |

<details>
  <summary>지난 팀원들</summary>

| 이름 |  박효준  |  손승재  |  신효성  |  엄지혜  |  정지용  |
| :------------: | :------------: | :------------: | :------------: | :------------: | :------------: |
|  | <img src="https://avatars.githubusercontent.com/u/129862357?s=400&u=b25bda6955bd46dcef49161230ca633947169589&v=4" width="80"/> | <img src="https://avatars.githubusercontent.com/u/46300191?v=4" width="80"/> | <img src="https://avatars.githubusercontent.com/u/57449485?v=4" width="80"/> | <img src="https://avatars.githubusercontent.com/u/63408930?v=4" width="80"> | <img src="https://avatars.githubusercontent.com/u/70135292?v=4" width="80"> |
| 깃허브 | [@Kyxxn](https://github.com/Kyxxn) | [@Sonny-Kor](https://github.com/Sonny-Kor) | [@N-Joy-Shadow](https://github.com/N-Joy-Shadow) | [@LURKS02](https://github.com/LURKS02) |  [@clxxrlove](https://github.com/clxxrlove)

</details>
  
##

<div align="center">
  
|📓 문서|[팀 노션](https://kyxxn.notion.site/to-duck-dfa389d8e7c94be2b35695f79d40e5a5?pvs=4)|[기획/디자인](https://www.figma.com/file/u270kM7D2YRtsbz6rsEYWk?node-id=0-1&p=f&t=ozuh8yXWdkYf52Dv-0&type=design&mode=design)|[데모 영상](https://kyxxn.notion.site/To-duck-2049adb326268030a845f97960593442?source=copy_link)|
|:-:|:-:|:-:|:-:|

</div>
