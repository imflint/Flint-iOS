# 🍿 FLINT iOS

<img width="100%" src="https://github.com/user-attachments/assets/f31e754b-8910-4167-95f2-ad08149a26e5" />

### FLINT는, 
누군가의 공감과 맥락이 담긴 추천을 통해 콘텐츠가 보고 싶어지는 순간이 반복되도록 만드는 **콘텐츠 추천 및 공유 서비스**입니다.
숫자와 랭킹 대신, 사람의 시선을 따라 취향을 발견하고 기록하는 경험을 제공합니다.

<br>

## 👥 iOS Developers

| <img src="https://github.com/rosejinse.png" width="100%"> | <img src="https://github.com/H0sungKim.png" width="100%"> | <img src="https://github.com/soeun11.png" width="100%"> |
|:------------------------------------------------------:|:------------------------------------------------------:|:----------------------------------------------------:|
| [**진소은**](https://github.com/rosejinse) | [**김호성**](https://github.com/H0sungKim)| [**임소은**](https://github.com/soeun11) |

<br>

## Library
| Library | 사용 이유 |
| ------- | -------------------------- |
| **SnapKit** | 선언적인 Auto Layout 작성을 위해 사용 |
| **Then** | 초기화 코드의 가독성 향상을 위해 사용 |
| **Moya** | 네트워크 레이어 추상화를 위해 사용 |
| **Lottie** | 가벼운 애니메이션 표현을 위해 사용 |
| **Combine** | 반응형 비동기 처리를 위해 사용 |

## Convention
[🖥️ Coding Convention](https://artistic-bacon-a40.notion.site/Code-Convention-2db50cdb714e80c7a6eadcc6ef84607f?source=copy_link)
<br>
[💬 Commit Convention](https://artistic-bacon-a40.notion.site/Commit-Convention-2db50cdb714e8000a23ce09b009c9a30?source=copy_link)
<br>
| 태그 | 설명 |
| --- | --- |
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `refactor` | 코드 리팩토링(전면 수정) |
| `docs` | 문서 관련 수정 |
| `chore` | 작은 수정 사항 반영 |
| `settings` | 프로젝트 세팅 관련 |
| `hotfix` | 긴급 수정 |
| `merge` | 작업 브랜치에서 메인 브랜치로 병합할 때 사용 |


## Git Flow
[🪾Git Flow](https://artistic-bacon-a40.notion.site/Git-Flow-2db50cdb714e80b9a1c0f90fc62a0a18?source=copy_link)

## Foldering
```markdown
📦 FLINT
│
├── 📂 Application
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
│
├── 📂 Core
│   └── 📂 Network
│       ├── 📂 API
│       ├── 📂 DTO
│       ├── 📂 Error
│       └── AppDIContainer.swift
│
├── 📂 Data
│   └── 📂 Repository
│
├── 📂 Domain
│   ├── 📂 Entity
│   ├── 📂 Interface
│   └── 📂 UseCase
│
├── 📂 Presentation
│   ├── 📂 Common
│   │   ├── 📂 Components
│   │   ├── 📂 Extensions
│   │   └── Assets
│   │
│   └── 📂 Home
│
└── Info.plist
```
