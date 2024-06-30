use fn_error_context::context;
use formality_prove::Env;
use formality_rust::{grammar::WhereClause, prove::ToWcs};
use formality_types::grammar::{Fallible, Wcs};

impl super::Check<'_> {
    #[context("prove_where_clauses_well_formed({where_clauses:?})")]
    pub(crate) fn prove_where_clauses_well_formed(
        &self,
        env: &Env,
        assumptions: impl ToWcs,
        where_clauses: &[WhereClause],
    ) -> Fallible<()> {
        let wcs: Wcs = where_clauses
            .into_iter()
            .flat_map(|wc| wc.well_formed().into_iter())
            .collect();
        self.prove_goal(env, assumptions, wcs)
    }
}
