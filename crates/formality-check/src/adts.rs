use std::collections::HashSet;

use anyhow::bail;
use formality_prove::Env;
use formality_rust::grammar::{Adt, AdtBoundData, Field, Variant};
use formality_types::grammar::Fallible;

impl super::Check<'_> {
    pub(super) fn check_adt(&self, adt: &Adt) -> Fallible<()> {
        let Adt { id: _, binder } = adt;

        // names is used to check that there are no name conflicts
        let mut names = HashSet::new();
        for Variant { name, fields } in &adt.binder.open().1.variants {
            if !names.insert((name, None)) {
                bail!("variant \"{name:?}\" defined multiple times");
            }
            let vname = name;
            for Field { name, ty: _ } in fields {
                if !names.insert((vname, Some(name))) {
                    bail!("field \"{name:?}\" of variant \"{vname:?}\" defined multiple times");
                }
            }
        }

        let mut env = Env::default();

        let AdtBoundData {
            where_clauses,
            variants,
        } = env.instantiate_universally(binder);

        self.prove_where_clauses_well_formed(&env, &where_clauses, &where_clauses)?;

        for Variant { name: _, fields } in &variants {
            for Field { name: _, ty } in fields {
                self.prove_goal(&env, &where_clauses, ty.well_formed())?;
            }
        }

        Ok(())
    }
}
