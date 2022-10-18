use formality_types::grammar::{KindedVarIndex, ProgramClause};

use crate::grammar::{AssociatedTy, AssociatedTyValue, Fn};

impl AssociatedTy {
    pub fn to_clauses(
        &self,
        trait_kinded_var_ids: &[KindedVarIndex],
        program: &crate::grammar::Program,
    ) -> Vec<ProgramClause> {
        unimplemented!()
    }
}

impl AssociatedTyValue {
    pub fn to_clauses(
        &self,
        _impl_kinded_var_ids: &[KindedVarIndex],
        _program: &crate::grammar::Program,
    ) -> Vec<ProgramClause> {
        unimplemented!()
    }
}
