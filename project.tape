@V := "tape" :: spec [active]
  version = "1.2"

@I := "phanes" :: identity [active]
  kind   = "Hosted autonomous-discovery platform (OUROBOROS loop · `hexa kick` engine)"
  brief  = "Tenants bring an objective + verifier; phanes drives the loop and returns a verified, provenance-tracked catalog."
  parent = "dancinlab"
  ssot   = "github.com/dancinlab/phanes (`hx install phanes`)"

@D t_downstream_discipline := "consume hexa kick; patch upstream" :: governance [required active]
  do   = "engine / multi-tenant gap → `hexa-lang/inbox/patches/<slug>.md` (one concept each) → upstream review"
  dont = "fork the hexa kick engine · inline downstream workaround · mix multiple concepts in one patch file"
