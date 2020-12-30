--!strict
-- formal type definitions for many common data structures

export type dictionary<K, V> = {
	[K] : V
}

export type list<T> = {
	[string] : T
}

export type array<T> = {
	[number] : T
}

export type enum<T> = {
	[string] : T
}
export type key_value_pair<K, V> = {
	key : K,
	value : V,
}

return {}