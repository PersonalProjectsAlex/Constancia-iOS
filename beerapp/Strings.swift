//
//  Strings.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/17/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

struct Strings {
    
    // Titles
    
    static let error = "Los sentimos"
    static let success = "Cheers!"
    static let incompleteFields = "Completa los campos"
    
    // Descriptions
    
    static let serverError = "Hubo un problema, intenta mas tarde."
    static let invalidUsernameOrPassword = "El usuario o contraseña es inavlido."
    static let birthdayEmpty = "Debe ingresar su fecha de cumpleaños."
    static let usernameEmpty = "Debe ingresar un nombre de usuario."
    static let nameEmpty = "Debe ingresar su nombre."
    static let passwordEmpty = "Debe ingresar una contraseña."
    static let confirmPasswordInvalid = "La contraseña que ingresó no coincide con el campo anterior."
    static let genderEmpty = "Debe seleccionar su genero para continuar."
    static let usernameInvalid = "El usuario debe contener mas de 3 caracteres."
    static let usernameExists = "EL nombre de usuario ya se encuentra registrtado."
    static let passwordInvalid = "La contrasena debe contener mas de 5 caractedes."
    static let emailExists = "Su email ya fue registrado con anterioridad."
    static let emailInvalid = "El email ingresado es invalido."
    static let userNotFound = "Lo sentimos su correo no esta registrado."
    static let passwordChangedSuccessfully = "Su contraseña se actualizo. ¡Por favor revise su correo!"
    
    // Tour
    
    static let tourTitles = [
        "Bares cerca de vos",
        "Las Mejores Promociones",
        "Gana Puntos"
    ]
    
    static let tourDescriptions = [
        "Encontrá los bares que andabas buscando y diviertete en cualquier partesdel país",
        "Siempre queremos tengas lo mejor por eso te notificaremos siempre que tengamos una promoción especial para vos",
        "Hace check en cada bar que visites y por cada registro obtén puntos, los cuales podes canjear en tu próxima visita"
    ]
    
    
    /*Fields*/
    
    static let wrongpassword = "La contraseña es incorrecta."
    static let wrongsuername = "Nombre de usuario incorrecto."
    static let wrongCharacteramount = "Ingrese un usuario de mas de 3 caracteres."
    
    /*Login*/
    static let userUnregistered = "Lo sentimos, no se encuentra registrado."
    /*General*/
    static let connectionError = "Debes estar conectado a una red."
    static let userNotFoundMesage = "No se encuentra registrado."
    
    static let successPasswordChange = "Su contraseña se actualizo. ¡Por favor revise su correo!"
    
    static let successPasswordUpdated = "Su contraseña se actualizo exitosamente."
    static let errorPasswordUpdated = "Sucedio un error por favor verifique sus datos."
    static let blankStateMessagePromotions = "No hay promociones disponibles por ahora."
    static let blankStateMessageProfile = "No hay datos por mostrar."
    
}

struct Title {
    static let empty = "Campo vacio:"
    static let empty2 = "Campos vacios:"
    static let password = "Contraseña:"
    static let user = "Usuario:"
    static let somethingWrong = "Algo sucedio mal:"
    static let Success = "¡Éxito!"
    static let blankStateTitle = "¡Lo sentimos!"
    static let info = "Información"
}

