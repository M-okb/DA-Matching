function DA_match(m_pref,n_pref)
    m = size(m_pref)[2]
    n = size(n_pref)[2]
    m_match = zeros(Int64, m)
    n_match = zeros(Int64, n)
    for turn in 1:n+1
        for man in 1:m
            if m_match[man] == 0          #「まだ婚約者がいない」かつ
                if find(m_pref[:,man] .==0)[1] > turn  #「結婚しないよりは、結婚したい人がいる」なら、プロポーズ発動
                  proposed = m_pref[turn,man]
                    if find(n_pref[:,proposed] .== man)[1] <
                        find(n_pref[:,proposed] .== n_match[proposed])[1]   #自分が相手の婚約者（いないなら、０）より、マシであれば成婚
                        if n_match[proposed] != 0           #婚約者がいれば、離婚します
                            m_match[n_match[proposed]] = 0
                        end
                        m_match[man] = proposed
                        n_match[proposed] = man
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