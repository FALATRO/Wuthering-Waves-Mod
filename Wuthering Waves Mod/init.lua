
-- Jokers

SMODS.Atlas({
    key = "worker",
    path = "zani.png",
    px = 71,
    py = 95
})

local joker_2 = SMODS.Joker({
    key = "worker",
    loc_txt = {
        name = "Sleepless Worker",
        text = {
            "Every scoring 9 or 5 gives",
            "{C:chips}+24 Chips{} and {C:mult}+7 Mult{}",
        }
    },
    rarity = 2,
    blueprint_compat = true,
    cost = 7,
    atlas = "worker",
    pos = {x = 0, y = 0},

    config = { extra = { mult = 7, chips = 24 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play 
        and (context.other_card:get_id() == 9 or context.other_card:get_id() == 5) then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
    end
})

SMODS.Atlas({
    key = "crystalization",
    path = "carlotta.png",
    px = 71,
    py = 95
})

local crystalization_joker = SMODS.Joker({
    key = "crystalization",
    loc_txt = {
        name = "Sophisticated Crystallization",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult for every",
            "{C:money}$#2#{} you have",
            "Currently: {X:mult,C:white}X#3#{}"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 12,
    atlas = "crystalization",
    pos = { x = 0, y = 0 },

    config = { extra = { Xmult = 0.5, dollars = 15 } },

    loc_vars = function(self, info_queue, card)
        local extra = (card and card.ability and card.ability.extra) or self.config.extra or { Xmult = 0.5, dollars = 15 }
        local step = extra.Xmult
        local dollars = extra.dollars
        local cash = ((G.GAME and (G.GAME.dollars or 0) or 0) + (G.GAME and (G.GAME.dollar_buffer or 0) or 0))
        return { vars = { step, dollars, 1 + step * math.floor(cash / dollars) } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local extra = (card and card.ability and card.ability.extra) or self.config.extra or { Xmult = 0.5, dollars = 15 }
            local step = extra.Xmult
            local dollars = extra.dollars
            local cash = ((G.GAME and (G.GAME.dollars or 0) or 0) + (G.GAME and (G.GAME.dollar_buffer or 0) or 0))
            return {
                Xmult = 1 + step * math.floor(cash / dollars)
            }
        end
    end,

    locked_loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.Xmult, self.config.extra.dollars, 1 } }
    end
})


SMODS.Atlas({
    key = "mysterious",
    path = "cantarella.png",
    px = 71,
    py = 95
})

local function count_blue_seals_safe()
    local seen = {}   
    local count = 0

    local function check_list(list)
        if not list then return end
        for _, c in ipairs(list) do
            if c and not seen[c] then
                seen[c] = true
                if c.seal then
                    local s = tostring(c.seal):lower()
                    
                    if s == "blue" or string.find(s, "blue", 1, true) then
                        count = count + 1
                    end
                end
            end
        end
    end

   
    if G then
        if G.GAME then
            check_list((G.GAME.deck and G.GAME.deck.cards) or nil)
            check_list(G.GAME.playing_cards)
        end
        check_list(G.playing_cards)
    end

    return count
end

local mysterious_joker = SMODS.Joker({
    key = "mysterious",
    loc_txt = {
        name = "Mysterious Maiden",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult for every",
            "{C:blue}Blue Seal{} in your full deck",
            "Currently: {X:mult,C:white}X#2#{}"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 8,
    atlas = "mysterious",
    pos = { x = 0, y = 0 },

    config = { extra = { Xmult = 0.5 } },

    loc_vars = function(self, info_queue, card)
        local extra = (card and card.ability and card.ability.extra) or self.config.extra
        local step = extra.Xmult or 0.5
        local blue_count = count_blue_seals_safe()
        local current_mult = 1 + (step * blue_count)
        return { vars = { step, current_mult } }
    end,

    calculate = function(self, card, context)
        if not context or not context.joker_main then return end

        local extra = (card and card.ability and card.ability.extra) or self.config.extra
        local step = extra.Xmult or 0.5
        local blue_count = count_blue_seals_safe()

        return { Xmult = 1 + (step * blue_count) }
    end,

    locked_loc_vars = function(self, info_queue, card)
        local extra = self.config.extra
        return { vars = { extra.Xmult, 1 } }
    end
})

SMODS.Atlas({
    key = "pero",
    path = "roccia.png",
    px = 71,
    py = 95
})

local PERO_joker = SMODS.Joker({
    key = "pero",
    loc_txt = {
        name = "PERO",
        text = {
            "{X:mult,C:white}X#1#{} Mult if all",
            "joker slots are full",
        }
    },

    rarity = 2,
    blueprint_compat = true,
    cost = 7,
    atlas = "pero",
    pos = { x = 0, y = 0 },

    config = { extra = { Xmult = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local max_slots = G.jokers.config.card_limit or 0
            local filled = #G.jokers.cards

            if filled >= max_slots and max_slots > 0 then

                return { Xmult = card.ability.extra.Xmult }
            end
        end
    end,
})

SMODS.Atlas({
    key = "seafaring",
    path = "brant.png",
    px = 71,
    py = 95
})

local seafaring_joker = SMODS.Joker({
    key = "seafaring",
    loc_txt = {
        name = "Seafaring",
        text = {
            "Gains {C:chips}+7 Chips{} permanently",
            "for each {C:blue}hand{} played",
            "Currently: {C:chips}+#1#{} Chips{}"
        }
    },

    rarity = 2,
    blueprint_compat = true,
    cost = 6,
    atlas = "seafaring",
    pos = { x = 0, y = 0 },

    config = { extra = { chips = 7, total = 0 } },

  
    loc_vars = function(self, info_queue, card)
        local extra = card.ability.extra
        return { vars = { extra.total } }
    end,

    calculate = function(self, card, context)
        
        if context.joker_main and card.ability.extra then
            card.ability.extra.total = card.ability.extra.total + card.ability.extra.chips
        end
  
        if context.joker_main then
            return { chips = card.ability.extra.total }
        end
    end,
})

SMODS.Atlas({
    key = "acolyte",
    path = "pheobe.png", 
    px = 71,
    py = 95
})


SMODS.Joker {
    key = "acolyte",
    loc_txt = {
        name = "Devoted Acolyte",
        text = {
            "All {C:attention}Boss Blind{} requirements",
            "are lowered by {C:green}25%{}",
        }
    },

    rarity = 3,
    blueprint_compat = false,
    cost = 10,
    pos = { x = 0, y = 0 },
    atlas = "acolyte", 

    config = {
        reduction = 0.25
    },

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and context.blind and context.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if G.GAME.blind and G.GAME.blind.chips then
                                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * (1 - self.config.reduction))
                                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            end
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = "-25% Boss Requirement" }, card)
                    return true
                end
            }))
            return nil, true
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            if G.GAME.blind.chips then
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * (1 - self.config.reduction))
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            end
            SMODS.calculate_effect({ message = "-25% Boss Requirement" }, card)
        end
    end
}


SMODS.Atlas({
    key = "bard",
    path = "ciaccona.png", 
    px = 71,
    py = 95
})

local bard_joker = SMODS.Joker({
    key = "bard",
    loc_txt = {
        name = "Common Bard",
        text = {
            "Gains {X:mult,C:white}X#1#{} for",
            "each {C:blue}Common Joker{}",
            "Currently: {X:mult,C:white}X#2#{}",          
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 8,
    pos = { x = 0, y = 0 },
    atlas = "bard", 

    config = { extra = { Xmult = 1 } },

    loc_vars = function(self, info_queue, card)
        local count = 1
        if G.jokers then
            for _, j in ipairs(G.jokers.cards) do
                if j.config and j.config.center and j.config.center.rarity == 1 then
                    count = count + 1
                end
            end
        end
        return { vars = { card.ability.extra.Xmult, count * card.ability.extra.Xmult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local count = 1
            for _, j in ipairs(G.jokers.cards) do
                if j.config and j.config.center and j.config.center.rarity == 1 then
                    count = count + 1
                end
            end
            if count > 0 then
                return {
                    Xmult = count * card.ability.extra.Xmult
                }
            end
        end
    end,
})

SMODS.optional_features.retrigger_joker = true

SMODS.Atlas({
    key = "two_sided",
    path = "camellya.png",
    px = 71,
    py = 95
})

local two_sided = SMODS.Joker({
    key = "two_sided",
    loc_txt = {
        name = "Two-Sided Face",
        text = {
            "Retriggers the {C:attention}right-most Joker{}",
            "{C:attention}two{} additional times",
            "but has a {C:green}#1# in #2# chance{}",
            "to {C:red}DESTROY{} a random one if",
            "any blind is selected"
        }
    },

    rarity = 3,
    blueprint_compat = false,
    cost = 10,
    pos = { x = 0, y = 0 },
    atlas = "two_sided",

    config = { extra = { chance = 6 } },

    loc_vars = function(self, info_queue, card)
       
        local numerator = G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal or 1
        local denominator = card.ability.extra.chance
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)

        if context.retrigger_joker_check then
            local jokers = G.jokers.cards
            if #jokers > 1 then
                local rightmost = jokers[#jokers]
                if context.other_card == rightmost and context.other_card ~= card then
                    return { repetitions = 2 }
                end
            end
        end

        if context.setting_blind and not context.blueprint then
            local chance = card.ability.extra.chance
            if pseudorandom("two_sided") < (G.GAME.probabilities.normal / chance) then
                if #G.jokers.cards > 1 then
                    local card_to_destroy = pseudorandom_element(G.jokers.cards, "random_destroy")
                    if card_to_destroy and card_to_destroy ~= card then
                        SMODS.destroy_cards(card_to_destroy)
                        SMODS.calculate_effect({ message = "Destroyed" }, card)
                        return
                    end
                end
            end
            return { message = localize('k_safe_ex') }
        end
    end
})


SMODS.Atlas({
    key = "butterfly",
    path = "shorekeeper.png",
    px = 71,
    py = 95
})

local butterfly = SMODS.Joker({
    key = "butterfly",
    loc_txt = {
        name = "Butterfly Memory",
        text = {
            "Creates a random {C:dark_edition}Negative{}",
            "{C:spectral}Spectral{} card when {C:attention}Boss Blind{}",
            "is selected"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 10,
    pos = { x = 0, y = 0 },
    atlas = "butterfly",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {
            key = 'e_negative_consumable',
            set = 'Edition',
            config = { extra = 1 }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind
            and context.blind
            and context.blind.boss then

            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({
                        set = 'Spectral',
                        edition = { negative = true }
                    })
                    return true
                end
            }))
        end
    end,
})

SMODS.Atlas({
    key = "lively",
    path = "encore.png",
    px = 71,
    py = 95
})

local lively = SMODS.Joker({
    key = "lively",
    loc_txt = {
        name = "Lively Child",
        text = {
            "Retriggers all {C:attention}played{}",
            "{C:attention}Enhanced{} cards"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 7,
    pos = { x = 0, y = 0 },
    atlas = "lively",

    config = { extra = { repetitions = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and next(SMODS.get_enhancements(context.other_card))then
            return {
                repetitions = 1
            }
        end
    end
})

SMODS.Atlas({
    key = "justice",
    path = "jiyan.png",
    px = 71,
    py = 95
})

local justice = SMODS.Joker({
    key = "justice",
    loc_txt = {
        name = "Warrior Justice",
        text = {
            "Gains {X:mult,C:white}X#1#{} for every",
            "{C:attention}Boss Blind{} defeated",
            "Currently: {X:mult,C:white}X#2#{}"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 8,
    pos = { x = 0, y = 0 },
    atlas = "justice",

    config = { extra = { gain = 0.5, bosses_defeated = 0 } },

    loc_vars = function(self, info_queue, card)
        local e = card.ability.extra
        return { vars = { e.gain, 1 + (e.bosses_defeated * e.gain) } }
    end,

    calculate = function(self, card, context)
        local e = card.ability.extra

        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
            e.bosses_defeated = e.bosses_defeated + 1
            return {
                message = "Victory will be ours",
                colour = G.C.MULT
            }
        end

        if context.joker_main then
            local total_mult = 1 + (e.bosses_defeated * e.gain)
            return { Xmult = total_mult }
        end
    end
})

SMODS.Atlas({
    key = "logical",
    path = "xiangli yao.png",
    px = 71,
    py = 95
})

local logical = SMODS.Joker({
    key = "logical",
    loc_txt = {
        name = "Logical Calculation",
        text = {
            "{C:red}+5{} Mult if played hand contains",
            "a {C:attention}Flush{}",
            "Currently: {C:red}+#3#{}"
        }
    },

    rarity = 2,
    blueprint_compat = true,
    cost = 7,
    pos = { x = 0, y = 0 },
    atlas = "logical",

  config = { extra = { mult_gain = 5, mult = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, localize('Flush', 'poker_hands'), card.ability.extra.mult } }
    end,
calculate = function(self, card, context)
    local mult_gain = card.ability.extra.mult_gain or 5
    local total_mult = card.ability.extra.mult or 0

    if context.before and not context.blueprint and context.poker_hands then
        local hands = context.poker_hands

        if (hands['Flush'] and next(hands['Flush'])) or
           (hands['Straight Flush'] and next(hands['Straight Flush'])) or
           (hands['Flush House'] and next(hands['Flush House'])) or
           (hands['Flush Five'] and next(hands['Flush Five'])) then

            total_mult = total_mult + mult_gain
            card.ability.extra.mult = total_mult

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end
    end

    if context.joker_main then
        return {
            mult = total_mult
        }
    end
end
})

SMODS.Atlas({
    key = "leader",
    path = "jinshi.png",
    px = 71,
    py = 95
})

local leader = SMODS.Joker({
    key = "leader",
    loc_txt = {
        name = "Driven Leader",
        text = {
            "Gains {C:red}+2{} Mult for every",
            "{C:attention}face{} card in your {C:attention}remaining deck{}", 
            "Currently: {C:red}+#1#{}"
        }
    },

    rarity = 2,
    blueprint_compat = true,
    cost = 7,
    pos = { x = 0, y = 0 },
    atlas = "leader",

    config = { extra = { mult = 2 } },

    loc_vars = function(self, info_queue, card)
        local count = 0
        if G and G.deck and G.deck.cards then
            for _, v in ipairs(G.deck.cards) do
                if v:is_face() then
                    count = count + 1
                end
            end
        end
        return { vars = { count * card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            if G and G.deck and G.deck.cards then
                for _, v in ipairs(G.deck.cards) do
                    if v:is_face() then
                        count = count + 1
                    end
                end
            end
            if count > 0 then
                return {
                    mult = count * card.ability.extra.mult
                }
            end
        end
    end
})


SMODS.Atlas({
    key = "artist",
    path = "zhezhi.png",
    px = 71,
    py = 95
})

local artist = SMODS.Joker({
    key = "artist",
    loc_txt = {
        name = "Expressive Artist",
        text = {
            "When any {C:attention}Blind{} is selected,",
            "create a random enhanced {C:attention}face{} card"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 7,
    pos = { x = 0, y = 0 },
    atlas = "artist",

 calculate = function(self, card, context)
    if context.setting_blind then

        local cen_pool = {}
        for _, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
            if v.key ~= "m_glass" and (v.key == "m_stone" or v.key == "m_bonus" or v.key == "m_wild" or v.key == "m_mult" or v.key == "m_steel") then
                table.insert(cen_pool, v)
            end
        end

        local selected_center = pseudorandom_element(cen_pool, pseudoseed("the_queen"))

        local suits = {"H", "D", "C", "S"}         
        local faces = {"J", "Q", "K"}              
        local rand_suit = suits[math.random(#suits)]
        local rand_face = faces[math.random(#faces)]

        local _card = create_playing_card({
            front = G.P_CARDS[rand_suit .. "_" .. rand_face],
            center = selected_center,
            area = G.discard
        })

        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:emplace(_card)
                _card:start_materialize()
                SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                return true
            end
        }))
    end
end
})

SMODS.Atlas({
    key = "monk",
    path = "jianxin.png",
    px = 71,
    py = 95
})

local monk = SMODS.Joker {
    key = "monk",
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    pos = { x = 0, y = 0 },
    atlas = "monk",

    config = { extra = { xchips = 2 } },

    loc_txt = {
        name = "Focused Monk",
        text = {
            "{X:chips,C:white}X2{} Chips if played hand",
            "contains only {C:attention}#2#s{}",
            "{C:inactive}(Suit changes each round){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.vremade_monk or {}).suit or "Spades"
        return {
            vars = {
                card.ability.extra.xchips,
                localize(suit, "suits_singular"),
                colours = { G.C.SUITS[suit] }
            }
        }
    end, 

    calculate = function(self, card, context)
        if context.joker_main then
            local chosen = (G.GAME.current_round.vremade_monk or {}).suit or "Spades"
            local all_match = true

            for _, played in ipairs(context.full_hand or {}) do
                if played.base.suit ~= chosen then
                    all_match = false
                    break
                end
            end

            if all_match then
             
                return { xchips = card.ability.extra.xchips }
            end
        end
    end
}  

local function reset_vremade_monk()
    G.GAME.current_round.vremade_monk = G.GAME.current_round.vremade_monk or { suit = "Spades" }
    local monk_suits = {}
    for _, v in ipairs({ "Spades", "Hearts", "Clubs", "Diamonds" }) do
        if v ~= G.GAME.current_round.vremade_monk.suit then
            monk_suits[#monk_suits + 1] = v
        end
    end
    local new_suit = pseudorandom_element(monk_suits, "vremade_monk" .. G.GAME.round_resets.ante)
    G.GAME.current_round.vremade_monk.suit = new_suit
end

SMODS.current_mod.reset_game_globals = function()
    reset_vremade_monk()
end

SMODS.Atlas({
    key = "puppet",
    path = "yinlin.png",
    px = 71,
    py = 95
})

local artist = SMODS.Joker({
    key = "puppet",
    loc_txt = {
        name = "Puppet Master",
        text = {
            "{X:mult,C:white}X2{} Mult if played hand",
            "contains {C:attention}five{} cards"
        }
    },

    rarity = 2,
    blueprint_compat = true,
    cost = 7,
    pos = { x = 0, y = 0 },
    atlas = "puppet",

     config = { extra = { Xmult = 2, size = 5 } },

       loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.size } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand == card.ability.extra.size then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
})

SMODS.Atlas({
    key = "photosyntheic",
    path = "verina.png",
    px = 71,
    py = 95
})

local photosyntheic = SMODS.Joker({
    key = "photosyntheic",
    loc_txt = {
        name = "Photosyntheic Rejuvenation",
        text = {
            "Gain {C:blue}+1{} Hand and {C:red}+1{} Discard",
            "when facing {C:attention}Boss Blinds{}"
        }
    },

    rarity = 2,
    blueprint_compat = true,
    cost = 7,
    pos = { x = 0, y = 0 },
    atlas = "photosyntheic",

    config = { extra = { hands = 1, discards = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands, card.ability.extra.discards } }
    end,

    calculate = function(self, card, context)
  
        if context.setting_blind and G.GAME.blind and G.GAME.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()

                    ease_hands_played(card.ability.extra.hands)
                    ease_discard(card.ability.extra.discards)
                    return true
                end
            }))

            return {
                message = "Photosynthesis",
                colour = G.C.GREEN
            }
        end
    end
})

SMODS.Atlas({
    key = "sighted",
    path = "changli.png",
    px = 71,
    py = 95
})

local sighted = SMODS.Joker({
    key = "sighted",
    loc_txt = {
        name = "True Sighted",
        text = {
            "Gains {X:mult,C:white}X0.1{} Mult if played",
            "hand contains a {C:attention}Pair{}",
            "Currently: {X:mult,C:white}X#3#{}"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 7,
    pos = { x = 0, y = 0 },
    atlas = "sighted",

    config = { extra = { Xmult_gain = 0.1, Xmult = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, localize('Pair', 'poker_hands'), card.ability.extra.Xmult } }
    end,

    calculate = function(self, card, context)
        local Xmult_gain = card.ability.extra.Xmult_gain or 0.1
        local total_Xmult = card.ability.extra.Xmult or 1

        if context.before and not context.blueprint and context.poker_hands then
            local hands = context.poker_hands

            if (hands['Pair'] and next(hands['Pair'])) or
               (hands['Two Pair'] and next(hands['Two Pair'])) or
               (hands['Three of a Kind'] and next(hands['Three of a Kind'])) or
               (hands['Four of a Kind'] and next(hands['Four of a Kind'])) or
               (hands['Five of a Kind'] and next(hands['Five of a Kind'])) or
               (hands['Full House'] and next(hands['Full House'])) or
               (hands['Flush House'] and next(hands['Flush House'])) or
               (hands['Flush Five'] and next(hands['Flush Five'])) then

                total_Xmult = total_Xmult + Xmult_gain
                card.ability.extra.Xmult = total_Xmult

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED
                }
            end
        end

        if context.joker_main then
            return {
                Xmult = total_Xmult
            }
        end
    end
})

SMODS.Atlas({
    key = "gladiator",
    path = "lupa.png",
    px = 71,
    py = 95
})

local gladiator = SMODS.Joker({
    key = "gladiator",
    loc_txt = {
        name = "Ruthless Gladiator",
        text = {
            "All scoring {C:attention}face{} cards give",
            "{X:mult,C:white}X#1#{} when facing {C:attention}Boss Blinds{}"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 8,
    pos = { x = 0, y = 0 },
    atlas = "gladiator",

    config = { extra = { xmult = 1.5 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if G.GAME.blind and G.GAME.blind.boss then
                local other = context.other_card
                if other and other:is_face() then
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end
    end
})



SMODS.Atlas({
    key = "sun",
    path = "augusta.png",
    px = 71,
    py = 95
})

local sun = SMODS.Joker({
    key = "sun",
    loc_txt = {
        name = "Solar Flares",
        text = {
            "Gives {X:mult,C:white}X3{} Mult on your",
            "{C:attention}first{} and {C:attention}last{} hand"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 8,
    pos = { x = 0, y = 0 },
    atlas = "sun",

    config = { extra = { Xmult = 3 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local round = G.GAME.current_round
            if (round.hands_played == 0) or (round.hands_left == 0) then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
})

SMODS.Atlas({
    key = "moon",
    path = "iuno.png",
    px = 71,
    py = 95
})

local sun = SMODS.Joker({
    key = "moon",
    loc_txt = {
        name = "Moon Revolution",
        text = {
            "Gives {C:mult}+28{} Mult on your",
            "{C:attention}first{} and {C:attention}last{} hand"
        }
    },

    rarity = 2,
    blueprint_compat = true,
    cost = 7,
    pos = { x = 0, y = 0 },
    atlas = "moon",

    config = { extra = { mult = 28 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local round = G.GAME.current_round
            if (round.hands_played == 0) or (round.hands_left == 0) then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
})

SMODS.Atlas({
    key = "knight",
    path = "cartethyia.png",
    px = 71,
    py = 95
})

local knight = SMODS.Joker({
    key = "knight",
    loc_txt = {
        name = "Wandering Knight",
        text = {
            "Played {C:attention}Aces{} give {X:mult,C:white}X2{} Mult",
            "but you lose half your hands"
        }
    },

    rarity = 3,
    blueprint_compat = true,
    cost = 15,
    pos = { x = 0, y = 0 },
    atlas = "knight",

    config = { extra = { Xmult = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,

calculate = function(self, card, context)

    if context.setting_blind and context.blind then

        if not card.ability.extra.hands_lost then
            local hands_left = G.GAME.current_round.hands_left or 0
            local to_remove = math.floor(hands_left / 2)
            if to_remove > 0 then
                G.GAME.current_round.hands_left = hands_left - to_remove
            end
        end
    end

    if context.individual and context.cardarea == G.play then
        local id = context.other_card:get_id()
        if id == 14 then
            return { Xmult = card.ability.extra.Xmult }
        end
    end
end
})

SMODS.Atlas({
    key = "chosen",
    path = "rover.png",
    px = 71,
    py = 95
})

local knight = SMODS.Joker({
    key = "chosen",
    loc_txt = {
        name = "CHOSEN ONE",
        text = {
            "All played {C:attention}Enhanced{} cards give",
            "{X:mult,C:white}X2{} Mult"
        }
    },

    rarity = 4,
    blueprint_compat = true,
    cost = 20,
    pos = { x = 0, y = 0 },
    atlas = "chosen",

    
    config = { extra = { Xmult = 2 } },

     loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,

    calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and next(SMODS.get_enhancements(context.other_card))then
            return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
})


-- Boss Blinds
SMODS.Atlas({
    key = "goat",
    path = "scar.png",
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 1
})

SMODS.Blind({
    key = "goat",
    loc_txt = {
        name = "The Goat",
        text = {
            "Cards with ranks 2-7",
            "are debuffed",
        },
    },
    atlas = "goat",
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = {
        min = 3,
        max = 0,
    },
    boss_colour = HEX('8B0000'), 

    recalc_debuff = function(self, card, from_blind)
    
        if card:get_id() == 2 or card:get_id() == 3 or card:get_id() == 4 or card:get_id() == 5 or card:get_id() == 6 or card:get_id() == 7 then
            return true 
        end
        return false
    end
})

SMODS.Atlas({
    key = "melody",
    path = "phrolova.png",
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 1
})

SMODS.Blind({
    key = "melody",
    loc_txt = {
        name = "The Melody",
        text = {
            "-1 hand size for every",
            "2 Jokers you own",
        },
    },
    atlas = "melody",
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = {
        min = 4,
        max = 0,
    },
    boss_colour = HEX('3C1361'),

    set_blind = function(self, context)
        if not self.disabled then
            local jokers = #G.jokers.cards
            local penalty = math.floor(jokers / 2)
            if penalty > 0 then
                G.hand:change_size(-penalty)
                self._hand_penalty = penalty 
            end
        end
    end,

    disable = function(self)
        if self._hand_penalty and self._hand_penalty > 0 then
            G.hand:change_size(self._hand_penalty)
            self._hand_penalty = nil
        end
    end,

    defeat = function(self)
        if self._hand_penalty and self._hand_penalty > 0 then
            G.hand:change_size(self._hand_penalty)
            self._hand_penalty = nil
        end
    end
})


SMODS.Atlas({
    key = "play",
    path = "cristoforo.png",
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 1
})


SMODS.Blind({
    key = "play",
    loc_txt = {
        name = "The Play",
        text = {
            "One of your highest rarity",
            "Jokers is debuffed"
        },
    },
    atlas = "play",
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = {
        min = 5,
        max = 0,
    },
    boss_colour = HEX('b38f00'),

    recalc_debuff = function(self, card, from_blind)
        if (card.area == G.jokers) and not G.GAME.blind.disabled then
 
            local max_rarity = 0
            for _, j in ipairs(G.jokers.cards) do
                if j.config.center.rarity and j.config.center.rarity > max_rarity then
                    max_rarity = j.config.center.rarity
                end
            end

            local candidates = {}
            for _, j in ipairs(G.jokers.cards) do
                if j.config.center.rarity == max_rarity then
                    table.insert(candidates, j)
                end
            end

            if not self._chosen_joker and #candidates > 0 then
                self._chosen_joker = pseudorandom_element(candidates, pseudoseed("play_blind"))
            end

            if self._chosen_joker and card == self._chosen_joker then
                return true
            end
        end
        return false
    end,

    disable = function(self)
        self._chosen_joker = nil
    end
})

-- Mod icon

SMODS.Atlas({
    key = "modicon",
    path = "WuWa_icon.png",
    px = 34,
    py = 34
})


