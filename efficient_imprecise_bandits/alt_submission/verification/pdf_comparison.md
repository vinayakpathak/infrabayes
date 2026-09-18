# Rendered PDF content and draft-colour audit

Source: 23 pages. Target: 32 pages.
The author line is intentionally excluded from comparison, as requested.

| Stream | Source characters | Target characters | Matched | Content differences | Colour differences |
| --- | ---: | ---: | ---: | ---: | ---: |
| Full normalized content | 51487 | 51619 | 98.353% | 789 | 0 |
| Prose letters | 39473 | 39739 | 99.664% | 55 | 0 |

## Interpretation

- This extraction audit does not replace source-level math audit or visual page review.
- Math font encoding, glyph substitution, and fraction/superscript reading order can produce false differences.
- Prose comparison excludes math fonts, whitespace, digits, punctuation, and discretionary line-end hyphens.
- Unicode NFKC normalizes ligatures and mathematical alphabet styling, so these styling distinctions need source/visual review.
- Colour is checked on matching character runs; unmatched characters remain unverified.

## Prose differences requiring review

- Source p.4: ``; target p.5: `inout`. Source context: `scanbeunstablewhenthetwoconstraintsjusttouchToallowsomenumericalslacktheimplementationusesItlooksforanarmwhoseinnersetisemptyandotherwiseplansagainsttheoutersetsTheupdaterulestillu`.
- Source p.4: ``; target p.6: `outout`. Source context: `tisnonemptywithenoughroomtocarryouttheremainingoptimizationDefinethevalueusedforplanningbyConvexdualitygiveswheresufficesThestrictmarginobtainedaboveiswhatletsusboundthedualvariabl`.
- Source p.4: ``; target p.6: `out`. Source context: `ughroomtocarryouttheremainingoptimizationDefinethevalueusedforplanningbyConvexdualitygiveswheresufficesThestrictmarginobtainedaboveiswhatletsusboundthedualvariableuniformlyoveralla`.
- Source p.4: ``; target p.6: `out`. Source context: `imesasfarfromastheearlierboundforThusthetwotypesofblocksstillcostandrespectivelyMaximizingtoadditiveaccuracyaddsatmosttotheregretTakingandroundingtheobservationstotheprecisionspeci`.
- Source p.5: ``; target p.8: `max`. Source context: `owtheblocklengthtovaryandusethequadraticformasapenaltyFortheanalysisfixandusethequantitiesdefinedinAppendixCWeusetheconcentrationboundfromLemmaandadapttheproofofLemmatothenewmatrix`.
- Source p.6: ``; target p.8: `max`. Source context: `nycompatibleadaptivepolicyThenAlgorithmruninexactarithmeticsatisfieswithprobabilityatleastwhereeachplanningcallmaximizestowithinWecanimplementthealgorithmintimepolynomialinandunder`.
- Source p.6: ``; target p.8: `max`. Source context: `eprecisionmodelTakinggivesexpectedregretThelearnerdoesnotneedtoknowortheanalysisquantitiesProofAsbeforeeachcompletedblockatleastdoublesthedeterminantThestoppingrulegivesSincethefin`.
- Source p.6: ``; target p.8: `max`. Source context: `oublesthedeterminantThestoppingrulegivesSincethefinaltraceisatmostThusifwecompleteblockssoWealsoneedtoboundhowfarcanjumpaboveoneonthelastobservationForconvexitygivesThefirsttermisl`.
- Source p.6: ``; target p.9: `max`. Source context: `eblocksempiricalmeanisinandtherewardisaffineItsregretisthereforeatmostAddingthisoveratmostblocksprovesthehighprobabilityboundIfthenoiseboundfailsregretisstillatmostsotakingexpectat`.
- Source p.7: ``; target p.9: `max`. Source context: `matingthetruevaluebutthiscostsonlyperroundwhichdecreasesasThetwotermstobalancearethereforeandgivingthesquarerootrateWestillneedtoimplementtheplanningstepFirstrewritethepenaltyasThe`.
- Source p.7: ``; target p.10: `op`. Source context: `tthenThelastboundonlycontrolsanincreasebutthisisallweneedtheobjectivehascoefficientonSincetherepairdecreasestheobjectivebyatmostwherewecantaketherationalboundChooseIncludingthesolv`.
- Source p.7: ``; target p.10: `max`. Source context: `dateandinvertthematricesandcomparethestoppingquantitywithitsthresholdexactlyThereareatmostplanningcallsandtheQCQPreductionabovemakeseachcallruninpolynomialtimeThisprovesthecomputat`.
- Source p.8: ``; target p.12: `NPBPP`. Source context: `edtobeasimplexIfforsomefixedarandomizedpolynomialtimelearnerguaranteesforeveryinstancethenIfadeterministiclearnerachievesthesameregretguaranteethenProofWereducefromMAXCUTasdefinedi`.
- Source p.8: ``; target p.12: `PNP`. Source context: `nerguaranteesforeveryinstancethenIfadeterministiclearnerachievesthesameregretguaranteethenProofWereducefromMAXCUTasdefinedinAppendixBLetbeaninstancewherehasverticesandedgesandOrien`.
- Source p.8: ``; target p.12: `for`. Source context: `xieifisorientedfromtothenrowhasincolumnincolumnandzeroselsewherePutWriteanoutcomeasandtakeLetbeaconstanttobechosenlaterForeveryletThisisoftheforminEquationwhereLettherewardbeThemap`.
- Source p.9: ``; target p.13: `eifotherwis`. Source context: `tothetwosidesandLetdenotethenumberofedgesbetweenthesesidesLemmaForeveryProofFixForeveryedgeSummingoverandtakingthesquarerootprovestheidentityFortheforwardimplicationsupposeisayesin`.
- Source p.10: ``; target p.14: `BPP`. Source context: `sufficientprecisionHenceLemmaimpliesthatarandomizedpolynomialtimelearnerwouldplaceMAXCUTinandthereforethatAdeterministiclearnerwouldinsteadimplyAEuclideanoutcomeballandapolytopeofa`.
- Source p.10: ``; target p.14: `NPBPP`. Source context: `ionHenceLemmaimpliesthatarandomizedpolynomialtimelearnerwouldplaceMAXCUTinandthereforethatAdeterministiclearnerwouldinsteadimplyAEuclideanoutcomeballandapolytopeofarmsWenowkeeptheE`.
- Source p.10: ``; target p.14: `PNP`. Source context: `ynomialtimelearnerwouldplaceMAXCUTinandthereforethatAdeterministiclearnerwouldinsteadimplyAEuclideanoutcomeballandapolytopeofarmsWenowkeeptheEuclideanoutcomeballandtheadditivebilin`.
- Source p.10: ``; target p.15: `NPBPP`. Source context: `mIfforsomefixedandpolynomialarandomizedpolynomialtimelearnerguaranteesforeveryinstancethenIfadeterministiclearnerachievesthesameregretguaranteethenProofWeagainreducefromMAXCUTLetha`.
- Source p.10: ``; target p.15: `PNP`. Source context: `nerguaranteesforeveryinstancethenIfadeterministiclearnerachievesthesameregretguaranteethenProofWeagainreducefromMAXCUTLethaveverticesandedgesOrienttheedgesarbitrarilyandletbetheedg`.
- Source p.11: ``; target p.15: `cut`. Source context: `notdecreaseApplyingthisreplacementonecoordinateatatimeproducesasignvectorwithAtasignvectorConsequentlySinceisstrictlyincreasinginifthemaximumcuthassizetheoptimalrobustvalueisForcon`.
- Source p.11: ``; target p.16: `MaxCut`. Source context: `pplyingthisreplacementonecoordinateatatimeproducesasignvectorwithAtasignvectorConsequentlySinceisstrictlyincreasinginifthemaximumcuthassizetheoptimalrobustvalueisForconsecutiveposs`.
- Source p.12: ``; target p.17: `nooptimalarmisplayed`. Source context: `gretguaranteeIfthelearnerneverplaysaoptimalarmthenMarkovsinequalityandthechoicesofandimplySelectaplayedarmmaximizingtherationalquantityandrounditscoordinatestoendpointswithoutdecre`.
- Source p.12: ``; target p.17: `NPBPP`. Source context: `utThehorizonthesquarerootapproximationsandtheroundingallhavepolynomialbitcomplexityprovingIfthelearnerisdeterministicthesameargumentsucceedswithcertaintyandgivesItremainstoverifyno`.
- Source p.12: ``; target p.17: `PNP`. Source context: `itcomplexityprovingIfthelearnerisdeterministicthesameargumentsucceedswithcertaintyandgivesItremainstoverifynontangencyForafixedputTheoutcomessatisfyingtheaffineconstraintformthelin`.
- Source p.13: ``; target p.19: `NPBPP`. Source context: `orsomefixedarandomizedpolynomialtimelearnerguaranteedoneverysuchinstanceforapolynomialthenForadeterministiclearnerthesameconclusionwouldbeProofWemayrestrictCLIQUEtoinstanceswithand`.
- Source p.13: ``; target p.19: `PNP`. Source context: `nteedoneverysuchinstanceforapolynomialthenForadeterministiclearnerthesameconclusionwouldbeProofWemayrestrictCLIQUEtoinstanceswithandsincewecandecidetheothercasesinpolynomialtimeGiv`.
- Source p.14: ``; target p.21: `NPBPP`. Source context: `vesanestimateofwithadditiveerroratmostwithprobabilityatleastComparingitwithdecidesCLIQUEsoForadeterministiclearnertheestimateisdeterministicandgivesComputingIUCBsfirstarmisNPhardev`.
- Source p.14: ``; target p.21: `PNP`. Source context: `stComparingitwithdecidesCLIQUEsoForadeterministiclearnertheestimateisdeterministicandgivesComputingIUCBsfirstarmisNPhardevenforEuclideanballsSupposewearegivenrationaldescriptionsof`.
- Source p.14: ``; target p.21: `IUCB`. Source context: `definingForeachhypothesisletOnitsfirstroundIUCBsconfidencesetisallofsoitsoptimisticvalueisWewillshowthatcomputingthisvalueexactlyisNPhardThesameistrueoffindinganarmTheoremComputing`.
- Source p.15: ``; target p.21: `IUCB`. Source context: `WewillshowthatcomputingthisvalueexactlyisNPhardThesameistrueoffindinganarmTheoremComputingexactlyorfindingagloballyoptimalfirstarmofIUCBisNPhardevenwhenandareEuclideanballsandplann`.
- Source p.15: ``; target p.22: `IUCB`. Source context: `nisknownButIUCBmustoptimizeoverbothandSinceisstrictlyincreasingandcanequalineverydirectionWecanthereforerecoverthetensornormfromtheoptimisticvalueIfwearegivenonlyagloballyoptimalar`.
- Source p.15: ``; target p.22: `IUCB`. Source context: `reasingandcanequalineverydirectionWecanthereforerecoverthetensornormfromtheoptimisticvalueIfwearegivenonlyagloballyoptimalarmdefinethematrixbyComputingitslargestsingularvaluegivesT`.
- Source p.15: ``; target p.22: `IUCB`. Source context: `eIfwearegivenonlyagloballyoptimalarmdefinethematrixbyComputingitslargestsingularvaluegivesThesameformulathenrecoverssofindingagloballyoptimalfirstarmisNPhardaswellEfficientplanning`.
- Source p.16: ``; target p.23: `CLIQUERP`. Source context: `retatmostforeveryinstanceinthisfamilyeverytruehypothesisandeverycompatiblenaturepolicyThenandhenceThesameconclusionholdsiftheguaranteeisrequiredonlyagainststationarydeterministicna`.
- Source p.16: ``; target p.23: `NPRP`. Source context: `tforeveryinstanceinthisfamilyeverytruehypothesisandeverycompatiblenaturepolicyThenandhenceThesameconclusionholdsiftheguaranteeisrequiredonlyagainststationarydeterministicnaturepoli`.
- Source p.16: ``; target p.23: `NPP`. Source context: `tstationarydeterministicnaturepoliciesAdeterministiclearnerwiththesameguaranteewouldimplyProofFixandletForeveryelementsetdefinebyandtakeAnarmisrepresentedsuccinctlybythevertexsetFo`.
- Source p.16: ``; target p.23: `ifotherwise`. Source context: `deterministiclearnerwiththesameguaranteewouldimplyProofFixandletForeveryelementsetdefinebyandtakeAnarmisrepresentedsuccinctlybythevertexsetForeveryelementsetdefinebyandletWriteanou`.
- Source p.16: ``; target p.23: `ifotherwise`. Source context: `mentsetdefinebyandtakeAnarmisrepresentedsuccinctlybythevertexsetForeveryelementsetdefinebyandletWriteanoutcomeasandsetWithconstraintspaceletanddefineForsetandletThemapsandarebiline`.
- Source p.16: ``; target p.24: `ifotherwise`. Source context: `theirdisplayedargumentsSinceisanoutcomecoordinatewecanwritetheconstraintaswithandlinearForThusinsidetheconstraintsforceforeveryandforeveryTheremainingcoordinatesarefreetovaryinThef`.
- Source p.17: ``; target p.24: `ifotherwise`. Source context: `wshowthatalearnerwiththestatedregretboundwouldsolveCLIQUEGivenagraphandtargetcliquesizeletIfisacliqueofnaturecanreturnoneveryroundunderhypothesiseveryedgeinsidehasandallthecoordina`.
- Source p.17: ``; target p.25: `NPRP`. Source context: `spolynomialtimewhenhasnocliqueThisisanRPalgorithmforCLIQUESinceCLIQUEisNPcompleteitimpliesIfthepolicyisdeterministicthesameverifiedsearchgivesThisexampleshowsthatefficientplanninga`.
- Source p.17: ``; target p.25: `PNP`. Source context: `CLIQUESinceCLIQUEisNPcompleteitimpliesIfthepolicyisdeterministicthesameverifiedsearchgivesThisexampleshowsthatefficientplanningalonedoesnotsufficeforefficientlearningItusesexponent`.
- Source p.19: ``; target p.27: `subjectto`. Source context: `icprogrammingForsymmetricmatricesaquadraticallyconstrainedquadraticprogramQCQPinhastheformwhereforcomplexitystatementsallentriesarerationalAquadraticequalityisexactlythepairandQCQP`.
- Source p.19: ``; target p.27: `suchthat`. Source context: `egraphFortheedgeboundaryofisThedecisionproblemMAXCUTtakesasinputandanintegerandaskswhetherAsetsatisfyingthisinequalityisapolynomialsizecertificatesoMAXCUTbelongstoNPKarpprovedthatw`.
- Source p.20: ``; target p.28: `maxmax`. Source context: `ullblockisinformativeifitcausesanupdateanduninformativeotherwiseFortheanalysisfixanddefineWewriteforthenumberofupdatesactuallymadeWewillshowthatIfisclosetothencannotbemuchsmallerth`.
- Source p.20: ``; target p.28: `max`. Source context: `eotherwiseFortheanalysisfixanddefineWewriteforthenumberofupdatesactuallymadeWewillshowthatIfisclosetothencannotbemuchsmallerthantheworstfeasiblerewardWefirstprovethisLemmaForeverya`.
- Source p.20: ``; target p.28: `op`. Source context: `safeasibleoutcomeintheunitballforeveryarmonTakinggivesandcomparingoppositeunitvectorsgivesNowdefineThismaphasoperatornormatmostandkerneltheoriginalconstraintsareequivalenttoandhomo`.
- Source p.21: ``; target p.30: `max`. Source context: `upposenaturefollowsanycompatibleadaptivepolicyThenAlgorithmsatisfieswithprobabilityatleastItsexpectedregretisatmostthesameexpressionplusTakingandgiveforfixedproblemparametersProofF`.
- Source p.21: ``; target p.30: `max`. Source context: `acesoTheinitialdeterminantisUsingthearithmeticgeometricmeaninequalityontheeigenvalueswegetSinceLemmagiveswithprobabilityatleastsimultaneouslyforeverymatrixthatthelearnermaintainsan`.
- Source p.21: ``; target p.30: `max`. Source context: `TheinitialdeterminantisUsingthearithmeticgeometricmeaninequalityontheeigenvalueswegetSinceLemmagiveswithprobabilityatleastsimultaneouslyforeverymatrixthatthelearnermaintainsandever`.
- Source p.21: ``; target p.31: `max`. Source context: `tmostThereareatmostsuchblocksforatotalofAninformativeblockmaycostasmuchasbutthereareatmostofthemAfinalincompleteblockalsocostsatmostAddingtheseboundsprovesthehighprobabilityclaimOu`.
- Source p.22: ``; target p.31: `out`. Source context: `ndisintheinteriorofMinimizingtheresultingaffineexpressionovertheunitballgivestheformulaforinitiallywithasupremumoverallToboundwritetheexpressioninsidethatsupremumasUsingandCauchySc`.
- Source p.22: ``; target p.32: `out`. Source context: `ionalupperapproximationstothecorrespondingnormsTheresultingobjectiveisavalidlowerboundonoratthereturnedarmIftheweakconstrainterrorisprojectionmoveseachvectorbyatmostthechangesinthe`.

## Matched prose with different draft colour

