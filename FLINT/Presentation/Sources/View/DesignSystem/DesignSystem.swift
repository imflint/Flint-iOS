//
//  File.swift
//  Presentation
//
//  Created by 김호성 on 2026.01.19.
//

import UIKit

/// Public Wrapper for Assets.xcassets basic extension
public enum DesignSystem {
    
    public enum Color {
        
        // MARK: - Common
        
        public static let background: UIColor = .flintBackground
        public static let error200: UIColor = .flintError200
        public static let error500: UIColor = .flintError500
        public static let error700: UIColor = .flintError700
        public static let overlay: UIColor = .flintOverlay
        public static let spoilerBlur: UIColor = .flintSpoilerBlur
        public static let white: UIColor = .flintWhite
        
        // MARK: - GrayScale
        
        public static let gray50: UIColor = .flintGray50
        public static let gray100: UIColor = .flintGray100
        public static let gray200: UIColor = .flintGray200
        public static let gray300: UIColor = .flintGray300
        public static let gray400: UIColor = .flintGray400
        public static let gray500: UIColor = .flintGray500
        public static let gray600: UIColor = .flintGray600
        public static let gray700: UIColor = .flintGray700
        public static let gray800: UIColor = .flintGray800
        public static let gray900: UIColor = .flintGray900
        
        // MARK: - Keyword
        
        public static let blue: UIColor = .flintBlue
        public static let green: UIColor = .flintGreen
        public static let orange: UIColor = .flintOrange
        public static let pink: UIColor = .flintPink
        public static let yellow: UIColor = .flintYellow
        
        // MARK: - Primary
        
        public static let primary50: UIColor = .flintPrimary50
        public static let primary100: UIColor = .flintPrimary100
        public static let primary200: UIColor = .flintPrimary200
        public static let primary300: UIColor = .flintPrimary300
        public static let primary400: UIColor = .flintPrimary400
        public static let primary500: UIColor = .flintPrimary500
        public static let primary600: UIColor = .flintPrimary600
        public static let primary700: UIColor = .flintPrimary700
        public static let primary800: UIColor = .flintPrimary800
        public static let primary900: UIColor = .flintPrimary900
        
        // MARK: - Secondary
        
        public static let secondary50: UIColor = .flintSecondary50
        public static let secondary100: UIColor = .flintSecondary100
        public static let secondary200: UIColor = .flintSecondary200
        public static let secondary300: UIColor = .flintSecondary300
        public static let secondary400: UIColor = .flintSecondary400
        public static let secondary500: UIColor = .flintSecondary500
        public static let secondary600: UIColor = .flintSecondary600
        public static let secondary700: UIColor = .flintSecondary700
        public static let secondary800: UIColor = .flintSecondary800
        public static let secondary900: UIColor = .flintSecondary900
    }
    
    public enum Icon {
        
        public enum Common {
            // TODO: - Temp 추후 Component로 변경 예정
            public static let collectionSave: UIImage = .icCollectionSave
            public static let collectionSaved: UIImage = .icCollectionSaved
            
            public static let bookmark: UIImage = .icBookmark
            public static let check: UIImage = .icBookmark
            public static let quilified: UIImage = .icBookmark
            public static let x: UIImage = .icBookmark
            
            public static let alert: UIImage = .icBookmark
            public static let back: UIImage = .icBookmark
            public static let bookmarkEmpty: UIImage = .icBookmark
            public static let bookmarkFillWhite: UIImage = .icBookmark
            public static let bookmarkFill: UIImage = .icBookmark
            public static let cancel: UIImage = .icBookmark
            public static let down: UIImage = .icBookmark
            public static let duplicate: UIImage = .icBookmark
            public static let exploreEmpty: UIImage = .icBookmark
            public static let homeEmpty: UIImage = .icBookmark
            public static let homeSelected: UIImage = .icBookmark
            public static let kebab: UIImage = .icBookmark
            public static let link: UIImage = .icBookmark
            public static let lock: UIImage = .icBookmark
            public static let more: UIImage = .icBookmark
            public static let myEmpty: UIImage = .icBookmark
            public static let mySelected: UIImage = .icBookmark
            public static let pencil: UIImage = .icBookmark
            public static let plus: UIImage = .icBookmark
            public static let searchSelected: UIImage = .icBookmark
            public static let search: UIImage = .icBookmark
            public static let send: UIImage = .icBookmark
            public static let setting: UIImage = .icBookmark
            public static let shareGray400: UIImage = .icBookmark
            public static let share: UIImage = .icBookmark
            public static let backgroundPhoto: UIImage = .icBookmark
            public static let checkboxEmpty: UIImage = .icBookmark
            public static let checkboxFill: UIImage = .icBookmark
            public static let deselect: UIImage = .icBookmark
            public static let profileChange: UIImage = .icBookmark
        }
        
        public enum Gradient {
            public static let bookmark: UIImage = .icBookmarkGradient
            public static let check: UIImage = .icCheckGradient
            public static let folder: UIImage = .icFolderGradient
            public static let home: UIImage = .icHomeGradient
            public static let lock: UIImage = .icLockGradient
            public static let magnifier: UIImage = .icMagnifierGradient
            public static let messages: UIImage = .icMessagesGradient
            public static let none: UIImage = .icNoneGradient
            public static let pencil: UIImage = .icPencilGradient
            public static let people: UIImage = .icPeopleGradient
            public static let picture: UIImage = .icPictureGradient
            public static let save: UIImage = .icSaveGradient
            public static let share: UIImage = .icShareGradient
            public static let trash: UIImage = .icTrashGradient
            public static let variant15: UIImage = .icVariant15Gradient
            
            public static let bookmarkSmall: UIImage = .icBookmarkGradientSmall
            public static let checkSmall: UIImage = .icCheckGradientSmall
            public static let folderSmall: UIImage = .icFolderGradientSmall
            public static let homeSmall: UIImage = .icHomeGradientSmall
            public static let lockSmall: UIImage = .icLockGradientSmall
            public static let magnifierSmall: UIImage = .icMagnifierGradientSmall
            public static let messagesSmall: UIImage = .icMessagesGradientSmall
            public static let noneSmall: UIImage = .icNoneGradientSmall
            public static let pencilSmall: UIImage = .icPencilGradientSmall
            public static let peopleSmall: UIImage = .icPeopleGradientSmall
            public static let pictureSmall: UIImage = .icPictureGradientSmall
            public static let saveSmall: UIImage = .icSaveGradientSmall
            public static let shareSmall: UIImage = .icShareGradientSmall
            public static let trashSmall: UIImage = .icTrashGradientSmall
        }
        
        public static let flintLogo: UIImage = .icFlintLogo
    }
    
    public enum Image {
        public enum Background {
            public static let backgroundGradient: UIImage = .imgBackgroundGradient
            public static let backgroundGradientLarge: UIImage = .imgBackgroundGradiantLarge
            public static let backgroundGradientMiddle: UIImage = .imgBackgroundGradiantMiddle
            public static let collectionBg: UIImage = .imgCollectionBg
        }
        
        public enum Common {
            public static let apple: UIImage = .imgApple
            public static let fab: UIImage = .imgFab
            public static let kakao: UIImage = .imgKakao
            public static let onboarding: UIImage = .imgOnboarding
            public static let profileBlue: UIImage = .imgProfileBlue
            public static let profileDefault: UIImage = .imgProfileDefault
            public static let profileGray: UIImage = .imgProfileGray
            public static let profilePurple: UIImage = .imgProfilePurple
            public static let profileSmallBlue: UIImage = .imgProfileSmallBlue
            public static let profileSmallGray: UIImage = .imgProfileSmallGray
            public static let profileSmallPurple: UIImage = .imgProfileSmallPurple
            public static let folder: UIImage = .imgFolder
        }
        
        public enum Logo {
            public static let coupang: UIImage = .imgCoupang
            public static let disney: UIImage = .imgDisney
            public static let netflix: UIImage = .imgNetflix
            public static let tving: UIImage = .imgTving
            public static let watcha: UIImage = .imgWatcha
            public static let wavve: UIImage = .imgWavve
            
            public static let coupangSmall: UIImage = .imgSmallCoupang1
            public static let disneySmall: UIImage = .imgSmallDisney1
            public static let netflixSmall: UIImage = .imgSmallNetflix1
            public static let tvingSmall: UIImage = .imgSmallTving1
            public static let watchaSmall: UIImage = .imgSmallWatcha1
            public static let wavveSmall: UIImage = .imgSmallWavve1
        }
        
        public enum Tag {
            public static let blue: UIImage = .imgTagBlue
            public static let green: UIImage = .imgTagGreen
            public static let orange: UIImage = .imgTagOrange
            public static let pink: UIImage = .imgTagPink
            public static let tellow: UIImage = .imgTagYellow
            public static let gray: UIImage = .tagGray
            
        }
    }
}
