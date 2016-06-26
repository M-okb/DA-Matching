function okb_DA_algo(
    prop_pref::Matrix{Int}, # preference of proposers
    resp_pref::Matrix{Int}, # preference of respondents
    capacities::Vector{Int}) # capacities of respondents

    prop_n = size(prop_pref, 2)
    resp_n = size(resp_pref, 2)
    
    prop_match = zeros(Int, prop_n)
    resp_match = zeros(Int, sum(capacities))
    
    indicator = Array(Int, resp_n + 1) # for making resp_match
    indicator[1] = 1
    for i in 1:resp_n
        indicator[i+1] = indicator[i] + capacities[i]
    end
    
    resp_rank = _prefs2ranks(resp_pref) # [1 0 2] -> [1 3 2] in order not to use find!()
    
    occupied = zeros(Int, resp_n) # Numbers of respondendts' occupied seats
    
    propose_count = ones(Int, prop_n)  # Array which means the number of times of propose
    
    single_prop = trues(prop_n) # Bool values which mean unmatched(0) or matched(1)
    
    while any(single_prop)
        for p in 1:prop_n
            if single_prop[p]
                r = prop_pref[propose_count[p], p] # p proposes r
                
                if r == 0  # Who is proposed is none
                    single_prop[p] = false
                    
                elseif resp_rank[p, r] > resp_rank[prop_n + 1, r]
                    # Proposal fails
                    
                elseif occupied[r] < capacities[r]
                    # some seats are vacant
                    prop_match[p] = r
                    resp_match[indicator[r] + occupied[r]] = p
                    single_prop[p] = false
                    occupied[r] += 1
                    
                else
                    #all seats are occupied
                    worst_rank = resp_match[indicator[r]] # Who is the least preferred among the currently accepted
                    worst_index = 0
                    for i in 1 : capacities[r] - 1
                        compared = resp_match[indicator[r] + i]
                        if resp_rank[worst_rank, r] < resp_rank[compared, r]
                            worst_rank = compared
                            worst_index = i
                        end
                    end
                    
                    if resp_rank[p, r] < resp_rank[worst_rank, r]
                        # preferred more than worst_rank
                        prop_match[p] = r
                        prop_match[worst_rank] = 0
                        resp_match[indicator[r] + worst_index] = p
                        single_prop[p] = false
                        single_prop[worst_rank] = true
                    end
                    
                end
                propose_count[p] += 1
            end
        end
    end
    return prop_match, resp_match, indicator
end

# case of one to one
function okb_DA_algo(
    prop_pref::Matrix{Int}, # preference of proposers
    resp_pref::Matrix{Int}) # preference of respondents
    
    capacities = ones(Int,size(resp_pref, 2))
    prop_match, resp_match, indicator =
    okb_DA_algo(prop_pref, resp_pref, capacities)
    return prop_match, resp_match
end


#from oyamad's sourse code(https://github.com/oyamad/Matching.jl/blob/master/src/deferred_acceptance.jl)
function _prefs2ranks{T<:Integer}(prefs::Matrix{T})
    unmatched = 0
    ranks = similar(prefs)
    m, n = size(prefs)
    for j in 1:n
        for i in 1:m
            k = prefs[i, j]
            if k == unmatched
                ranks[end, j] = i
            else
                ranks[k, j] = i
            end
        end
    end
    return ranks
end