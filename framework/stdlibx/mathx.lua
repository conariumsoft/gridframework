local mathx = setmetatable({}, {__index = math})

type n = number;
function mathx.clamp(value: n, min: n, max: n) : n
    return math.max(math.min(value, max), min);
end
function mathx.precision(val:n, decimals:n)
    return math.floor(val*decimals+0.5)/decimals;
end
function mathx.multipleof(val: n, mult: n): n
    return math.precision(val/mult)*mult;
end
function mathx.decay(low: n, high: n, rate: n, dt: n) : n
    return mathx.lerp(low, high, 1.0 - math.exp(-rate * dt));
end
function mathx.smoothstep(prog: n, low: n, high: n): n
    local t: n = math.clamp(( prog-low) / (high-low), 0.0, 1.0);
    return t * t * (3.0-2.0 * t);
end
function mathx.map(value: n, min_in: n, max_in: n, min_out: n, max_out: n) : n
	return ((value) - (min_in)) * ((max_out) - (min_out)) / ((max_in) - (min_in)) + (min_out);
end

function mathx.lerp(low:n , high: n, prog: n): n
    return low * (1 - prog) + high * prog;
end

function mathx.lerpv2(low: Vector2, high: Vector2, alpha:number) : Vector2
    return Vector2.new(
        mathx.lerp(low.X, high.X, alpha),
        mathx.lerp(low.Y, high.Y, alpha)
    );
end
function mathx.lerpv3(low: Vector3, high: Vector3, alpha:number) : Vector3
    return Vector3.new(
        mathx.lerp(low.X, high.X, alpha),
        mathx.lerp(low.Y, high.Y, alpha),
        mathx.lerp(low.Z, high.Z, alpha)
    );
end
--linear interpolation with a minimum "final step" distance
--useful for making sure dynamic lerps do actually reach their final destination
function mathx.lerp_eps(a, b, t, eps)
	local v = mathx.lerp(a, b, t)
	if math.abs(v - b) < eps then
		v = b
	end
	return v
end
function mathx.bilerp(a: n, b: n, c: n, d: n, u: n, v: n) : n
	return mathx.lerp( mathx.lerp(a, b, u), mathx.lerp(c, d, u), v)
end
mathx.tau = math.pi * 2

--normalise angle onto the interval [-math.pi, math.pi)
--so each angle only has a single value representing it
function mathx.normalise_angle(a)
	return mathx.wrap(a, -math.pi, math.pi)
end

--alias for americans
mathx.normalize_angle = mathx.normalise_angle

--get the normalised difference between two angles
function mathx.angle_difference(a, b)
	a = mathx.normalise_angle(a)
	b = mathx.normalise_angle(b)
	return mathx.normalise_angle(b - a)
end
--mathx.lerp equivalent for angles
function mathx.lerp_angle(a, b, t)
	local dif = mathx.angle_difference(a, b)
	return mathx.normalise_angle(a + dif * t)
end

--mathx.lerp_eps equivalent for angles
function mathx.lerp_angle_eps(a, b, t, eps)
	--short circuit to avoid having to wrap so many angles
	if a == b then
		return a
	end
	--same logic as lerp_eps
	local v = mathx.lerp_angle(a, b, t)
	if math.abs(mathx.angle_difference(v, b)) < eps then
		v = b
	end
	return v
end
return mathx;