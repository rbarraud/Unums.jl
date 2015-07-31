

@generated function Base.zero{B,E,U}(::Type{FixedUnum{B,E,U}})
  c = unumConstants(B,E,U)
  :(_i2u($B,$E,$(c.zero)))
end

# convert any floating point number to a unum
# lets worry about the base-2 case for now, then generalize later:
@generated function call{E,UINT, FLOAT<:FloatingPoint}(::Type{Unum{E,UINT}}, x::FLOAT)
  B = 2
  c = unumConstants(B, E, UINT)
  f = FloatInfo(FLOAT)

  # this is the actual conversion function:
  quote
    println($(f.uintType))

    ival = reinterpret($(f.uintType), x)
    exponent = (ival & $(f.emask)) >> $(f.fpos)
    fraction = (ival & $(f.fmask))
    sign = ival >> $(f.nbits-1)

    if exponent == 0
      if fraction == 0
        # zero (exact)
        return _i2u($B,$E,$(c.zero))
      end
    end

    # for x in (ival, exponent, fraction, sign)
    #   println(bits(x))
    # end

  end
end
