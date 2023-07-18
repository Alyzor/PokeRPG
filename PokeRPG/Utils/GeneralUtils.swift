//
//  GeneralUtils.swift
//  PokeRPG
//
//  Created by Alyzor on 10/07/2023.
//

import Foundation
import SwiftUI

class PokemonHeals{
    func fullHealSingle(pokemon:Pokemon) -> Pokemon{
        var sent = pokemon
        sent.HP = pokemon.permaStats.HP
        
        return sent
    }
    func fullHealTeam(team:PokemonTeam) -> PokemonTeam{
        var sendTeam:PokemonTeam = team
        
        sendTeam.Pkmn.indices.forEach { pkm in
            sendTeam.Pkmn[pkm].HP = sendTeam.Pkmn[pkm].permaStats.HP
            sendTeam.Pkmn[pkm].ATK = sendTeam.Pkmn[pkm].permaStats.ATK
            sendTeam.Pkmn[pkm].DEF = sendTeam.Pkmn[pkm].permaStats.DEF
            sendTeam.Pkmn[pkm].spATK = sendTeam.Pkmn[pkm].permaStats.spATK
            sendTeam.Pkmn[pkm].spDEF = sendTeam.Pkmn[pkm].permaStats.spDEF
            sendTeam.Pkmn[pkm].SPD = sendTeam.Pkmn[pkm].permaStats.SPD
            sendTeam.Pkmn[pkm].MoveList.indices.forEach { i in
                sendTeam.Pkmn[pkm].MoveList[i].pp = sendTeam.Pkmn[pkm].MoveList[i].maxPP
                
            }
        }
        return sendTeam
    }
}
