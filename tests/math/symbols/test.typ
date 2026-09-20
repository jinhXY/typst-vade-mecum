#import "/src/math.typ": AA, NN, QQ, RR, ZZ, add_space, hfrac, scr, sfrac, suchthat

// --- double-struck letters --------------------------------------------------

#assert.eq(AA, $bb(A)$)
#assert.eq(NN, $bb(N)$)
#assert.eq(QQ, $bb(Q)$)
#assert.eq(RR, $bb(R)$)
#assert.eq(ZZ, $bb(Z)$)
#assert.ne(NN, RR, message: "different letters must not collide")

// All 26 shorthands exist, are content, and match their letter.
#{
    import "/src/math.typ": (
        BB, CC, DD, EE, FF, GG, HH, II, JJ, KK, LL, MM, OO, PP, SS, TT, UU, VV, WW, XX, YY,
    )
    let pairs = (
        ("A", AA, $bb(A)$),
        ("B", BB, $bb(B)$),
        ("C", CC, $bb(C)$),
        ("D", DD, $bb(D)$),
        ("E", EE, $bb(E)$),
        ("F", FF, $bb(F)$),
        ("G", GG, $bb(G)$),
        ("H", HH, $bb(H)$),
        ("I", II, $bb(I)$),
        ("J", JJ, $bb(J)$),
        ("K", KK, $bb(K)$),
        ("L", LL, $bb(L)$),
        ("M", MM, $bb(M)$),
        ("N", NN, $bb(N)$),
        ("O", OO, $bb(O)$),
        ("P", PP, $bb(P)$),
        ("Q", QQ, $bb(Q)$),
        ("R", RR, $bb(R)$),
        ("S", SS, $bb(S)$),
        ("T", TT, $bb(T)$),
        ("U", UU, $bb(U)$),
        ("V", VV, $bb(V)$),
        ("W", WW, $bb(W)$),
        ("X", XX, $bb(X)$),
        ("Y", YY, $bb(Y)$),
        ("Z", ZZ, $bb(Z)$),
    )
    assert.eq(pairs.len(), 26)
    for (letter, shorthand, expected) in pairs {
        assert.eq(type(shorthand), content, message: "shorthand for " + letter)
        assert.eq(shorthand, expected, message: "shorthand for " + letter)
    }
}

// --- add_space --------------------------------------------------------------

#assert.eq(type(add_space(sym.forall, 0.5em, 0em)), content)
#assert.eq(type(suchthat), content)

// --- scr --------------------------------------------------------------------

#assert.eq(type(scr("F")), content)

// --- rendering --------------------------------------------------------------

$ forall x in RR, exists n in NN quad suchthat quad n > x $

$ scr("F") subset scr("G") $

#sfrac($ 1 / 2 + x / y $)
#hfrac($ 1 / 2 + x / y $)

#assert.eq(type(sfrac($1 / 2$)), content)
#assert.eq(type(hfrac($1 / 2$)), content)
