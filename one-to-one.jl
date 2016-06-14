function DA_algo(m_pref::Array{Int64}, n_pref::Array{Int64}) #引数は選考表
    m = size(m_pref,2)
    n = size(n_pref,2)
    m_match = zeros(Int64, m) 
    n_match = zeros(Int64, n)   #マッチング結果vectorの作成
    propose_number = zeros(Int64,m)  #告白回数の記憶vecotr
    no_propose = Int[]  #それぞれが「もう告白しなくなる」告白回数vector
    for man in 1:m
        push!(no_propose, find(m_pref[:, man] .== 0)[1] - 1)
    end
    while any(m_match .== 0) == true
        mikon = find(m_match .== 0)  #未婚menVector
        if all(propose_number[mikon] .>= no_propose[mikon]) == true
            break  #未婚menが「告白しない」状態なら脱loop
        else
            for each_mikon in mikon
                proposed = m_pref[propose_number[each_mikon] + 1, each_mikon]  #次のプロポーズ相手
                if proposed != 0
                    propose_number[each_mikon] += 1 #告白回数に+1
                    if find(n_pref[:,proposed] .== each_mikon)[1] < find(n_pref[:,proposed] .== n_match[proposed])[1]  #自分が相手の婚約者（いないなら、０）より、マシであれば成婚
                        if n_match[proposed] != 0           #婚約者がいれば、離婚します
                            m_match[n_match[proposed]] = 0
                        end
                    m_match[each_mikon] = proposed
                    n_match[proposed] = each_mikon
                    end
                end
            end
        end
    end
    return m_match, n_match
end

    function pref(m,n) #ランダム選考表の作成(今回は使わない)
        m_pref = shuffle!(collect(0:n))
        n_pref = shuffle!(collect(0:m))
        #1列目だけ作成しておく
        for i in　2:m
            each = shuffle!(collect(0:n))
            m_pref = hcat(m_pref, each)
        end
        for i in 2:n
            each = shuffle!(collect(0:m))
            n_pref = hcat(n_pref,each)
        end
        #あとはそれぞれloop
        return m_pref, n_pref
    end