module std::collections::maybe <Type>;
import std::io;

struct MaybeLiteral (Printable)
{
	Type value;
	bool has_value;
}

typedef MaybePtr = Type;

alias Maybe = Type::kind == POINTER ??? MaybePtr : MaybeLiteral;

const Maybe EMPTY = { };

fn Maybe value(Type val)
{
  $if Maybe == MaybePtr:
    return (Maybe) val;
  $else
	  return { .value = val, .has_value = true };
  $endif
}

fn sz? Maybe.to_format(Maybe* self, Formatter* f) @dynamic
{
  $if Maybe == MaybePtr:
    if (*self) return f.printf("[%s]", *((Type) self));
    return f.printf("[EMPTY]");
  $else
    if (self.has_value) return f.printf("[%s]", self.value);
    return f.printf("[EMPTY]");
  $endif
}

fn void Maybe.set(&self, Type val)
{
  $if Maybe == MaybePtr:
    *self = (Maybe) val;
  $else
    *self = { .value = val, .has_value = true };
  $endif
}

fn void Maybe.reset(&self)
{
  *self = {};
}

macro Type? Maybe.get(self)
{
  $if Maybe == MaybePtr:
    return self ? (Type) self : NOT_FOUND~;
  $else
    return self.has_value ? self.value : NOT_FOUND~;
  $endif
}

fn bool Maybe.equals(self, Maybe other) @operator(==) @if(types::is_equatable_type(Type))
{
  $if Maybe == MaybePtr:
    if (self)
    {
      return other && ((Type) self) == ((Type) other);
    }
    return !other;
  $else
    if (self.has_value)
    {
      return other.has_value && equals(self.value, other.value);
    }
    return !other.has_value;
  $endif
}

