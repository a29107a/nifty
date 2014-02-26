{% if phase=="prepare" %}
	{% if argument|is_argument %}
	ERL_NIF_TERM *tpl{{N}};
	int arity{{N}};
	uint64_t {{carg}};
	{% endif %}
	{% if argument|is_return %}
	uint64_t c_retval; 
	ERL_NIF_TERM retval;
	{% endif %}
	{% if argument|is_field %}
		{% if record=="to_record" %}
	ERL_NIF_TERM {{erlarg}};
		{% endif %}
		{% if record=="to_ptr" %}
	ERL_NIF_TERM *tpl{{N}};
	int arity{{N}};
		{% endif %}
	{% endif %}
{% endif %}

{% if phase=="to_c" %}
	if (!enif_compare({{erlarg}}, enif_make_atom(env, "null"))) {
		{{carg}} = 0;
	} else {
		err = enif_get_tuple(env, {{erlarg}}, &arity{{N}}, (const ERL_NIF_TERM**)(&tpl{{N}}));
		if (err) {
			if (arity{{N}}>2) {
				err = 0;
			} else {
				err = enif_get_uint64(env, tpl{{N}}[0], (uint64_t*)&{{carg}});
			}
		}
	}
{% endif %}

{% if phase=="argument" %}
{% if argument|is_argument %}
({{raw_type}}){{carg}}
{% else %}
(uint64_t)
{% endif %}
{% endif %}

{% if phase=="to_erl" %}
	{{erlarg}} = enif_make_tuple2(
		env,
		enif_make_uint64(env, (uint64_t){{carg}}),
		enif_make_string(env, "{{module}}.{{type}}", ERL_NIF_LATIN1));
{% endif %}
