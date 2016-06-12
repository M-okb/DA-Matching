function DA_match(m,n)
    function pref(m,n) #選考表の作成
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

    men = 1:m
    wemen = 1:n
    m_match = zeros(Int64,m)
    n_match = zeros(Int64,n)
    m_pref, n_pref = pref(m,n)
    for turn in 1:n+1
        for man in men
            if m_match[man] == 0
                #「既に婚約者がいない」かつ
                if find(m_pref[:,man] .==0)[1] < turn
                    #「結婚しないほうがマシ」なら、プロポーズ発動
                    #なんかfindがarrayで返されるので[1]つけてます
                    if find(n_pref[:,m_pref[turn,man]] .== man)[1] < find(n_pref[:,m_pref[turn,man]] .== n_match[m_pref[turn,man]])[1] 
                        #自分が相手の婚約者（いないなら、０）より、マシであれば成婚
                        if n_match[m_pref[turn,man]] != 0
                            m_match[n_match[m_pref[turn,man]]] = 0
                        end
                        m_match[man] = m_pref[turn,man]
                        n_match[m_pref[turn,man]] = man
                    end
                end
            end
        end
    end
return m_match, n_match
end