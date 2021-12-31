# Changelog

## [Unreleased](https://github.com/gjtorikian/html-proofer/tree/HEAD)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.19.2...HEAD)

**Fixed bugs:**

- mailto without email shouldn't fail [\#552](https://github.com/gjtorikian/html-proofer/issues/552)

**Closed issues:**

- links without html suffix claimed to be broken [\#654](https://github.com/gjtorikian/html-proofer/issues/654)
- Unexpected 404 link [\#648](https://github.com/gjtorikian/html-proofer/issues/648)
- Thread 0 Crashes on M1 chip \(MacOS Big Sur 13.1\) [\#646](https://github.com/gjtorikian/html-proofer/issues/646)
- Add GitHub Action wrappers to README? [\#642](https://github.com/gjtorikian/html-proofer/issues/642)
- Add support for site.baseurl, workaround [\#618](https://github.com/gjtorikian/html-proofer/issues/618)
- Some URLs are reported invalid but are in fact OK [\#581](https://github.com/gjtorikian/html-proofer/issues/581)
- Internally linking to \<valid URL\> which does not exist [\#542](https://github.com/gjtorikian/html-proofer/issues/542)

**Merged pull requests:**

- Add typhoeus-config user agent and cookies snippets to the README [\#666](https://github.com/gjtorikian/html-proofer/pull/666) ([JackWilb](https://github.com/JackWilb))
- Run htmlproofer and precede it with the correct ruby binary [\#665](https://github.com/gjtorikian/html-proofer/pull/665) ([dleidert](https://github.com/dleidert))
- Document how to adjust for a baseurl [\#658](https://github.com/gjtorikian/html-proofer/pull/658) ([PeterJCLaw](https://github.com/PeterJCLaw))
- Add flag to allow no-email mailto links [\#657](https://github.com/gjtorikian/html-proofer/pull/657) ([PeterJCLaw](https://github.com/PeterJCLaw))
- fix redirect \(after changing name of master branch\) [\#653](https://github.com/gjtorikian/html-proofer/pull/653) ([matkoniecz](https://github.com/matkoniecz))
- Add example using proof-html GitHub action [\#651](https://github.com/gjtorikian/html-proofer/pull/651) ([anishathalye](https://github.com/anishathalye))
- Replace Nokogumbo with Nokogiri [\#650](https://github.com/gjtorikian/html-proofer/pull/650) ([stevecheckoway](https://github.com/stevecheckoway))
- Apply Uniq filter to remove duplicate issues [\#649](https://github.com/gjtorikian/html-proofer/pull/649) ([uberfuzzy](https://github.com/uberfuzzy))

## [v3.19.2](https://github.com/gjtorikian/html-proofer/tree/v3.19.2) (2021-06-24)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.19.1...v3.19.2)

**Closed issues:**

- Passing hydra options from CLI is broken [\#644](https://github.com/gjtorikian/html-proofer/issues/644)
- Add caching note for GitHub Actions [\#639](https://github.com/gjtorikian/html-proofer/issues/639)
- Fatal error in 3.19.1\(sh: gcc: not found\) [\#638](https://github.com/gjtorikian/html-proofer/issues/638)

**Merged pull requests:**

- Allow `--hydra-config` to symbolize opts [\#645](https://github.com/gjtorikian/html-proofer/pull/645) ([gjtorikian](https://github.com/gjtorikian))

## [v3.19.1](https://github.com/gjtorikian/html-proofer/tree/v3.19.1) (2021-04-18)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.19.0...v3.19.1)

**Closed issues:**

- Invalid User-Agent [\#634](https://github.com/gjtorikian/html-proofer/issues/634)

**Merged pull requests:**

- Address wild double UA bug [\#637](https://github.com/gjtorikian/html-proofer/pull/637) ([gjtorikian](https://github.com/gjtorikian))

## [v3.19.0](https://github.com/gjtorikian/html-proofer/tree/v3.19.0) (2021-04-11)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.18.8...v3.19.0)

**Closed issues:**

- 301s are returned as 404s [\#631](https://github.com/gjtorikian/html-proofer/issues/631)
- doi.org error [\#629](https://github.com/gjtorikian/html-proofer/issues/629)

**Merged pull requests:**

- Add --hydra-config flag to override concurrency from CLI [\#632](https://github.com/gjtorikian/html-proofer/pull/632) ([patcon](https://github.com/patcon))

## [v3.18.8](https://github.com/gjtorikian/html-proofer/tree/v3.18.8) (2021-03-04)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.18.7...v3.18.8)

## [v3.18.7](https://github.com/gjtorikian/html-proofer/tree/v3.18.7) (2021-03-04)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.18.6...v3.18.7)

**Closed issues:**

- Thanks! [\#627](https://github.com/gjtorikian/html-proofer/issues/627)
- Old links not actually removed from the cache [\#625](https://github.com/gjtorikian/html-proofer/issues/625)
- 3.18.6 broke before\_request [\#624](https://github.com/gjtorikian/html-proofer/issues/624)

**Merged pull requests:**

- Resolve URL detection issues when using a cache [\#628](https://github.com/gjtorikian/html-proofer/pull/628) ([gjtorikian](https://github.com/gjtorikian))
- Do a better job preserving cache logic [\#626](https://github.com/gjtorikian/html-proofer/pull/626) ([gjtorikian](https://github.com/gjtorikian))

## [v3.18.6](https://github.com/gjtorikian/html-proofer/tree/v3.18.6) (2021-02-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.18.5...v3.18.6)

**Closed issues:**

- By default Middleware ignores all URLs [\#621](https://github.com/gjtorikian/html-proofer/issues/621)
- Internal links cache seems to remove cached external links [\#620](https://github.com/gjtorikian/html-proofer/issues/620)
- Links to Twitter profiles are treated as broken even though they aren't [\#619](https://github.com/gjtorikian/html-proofer/issues/619)

**Merged pull requests:**

- Handle internal & external cache merging [\#623](https://github.com/gjtorikian/html-proofer/pull/623) ([gjtorikian](https://github.com/gjtorikian))
- Correct link ignore regexp [\#622](https://github.com/gjtorikian/html-proofer/pull/622) ([gjtorikian](https://github.com/gjtorikian))

## [v3.18.5](https://github.com/gjtorikian/html-proofer/tree/v3.18.5) (2021-01-02)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.18.4...v3.18.5)

**Closed issues:**

- NoMethodError thrown with certain malformed URLs [\#615](https://github.com/gjtorikian/html-proofer/issues/615)

**Merged pull requests:**

- Catch bad URLs [\#616](https://github.com/gjtorikian/html-proofer/pull/616) ([gjtorikian](https://github.com/gjtorikian))

## [v3.18.4](https://github.com/gjtorikian/html-proofer/tree/v3.18.4) (2021-01-02)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.18.3...v3.18.4)

## [v3.18.3](https://github.com/gjtorikian/html-proofer/tree/v3.18.3) (2020-12-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.18.2...v3.18.3)

**Merged pull requests:**

- Allow usage of Ruby 3.0 [\#613](https://github.com/gjtorikian/html-proofer/pull/613) ([tisba](https://github.com/tisba))

## [v3.18.2](https://github.com/gjtorikian/html-proofer/tree/v3.18.2) (2020-12-17)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.18.1...v3.18.2)

**Closed issues:**

- I still experience the issue \#607 with release 3.18.1 [\#611](https://github.com/gjtorikian/html-proofer/issues/611)

**Merged pull requests:**

- Fix internal link problem [\#612](https://github.com/gjtorikian/html-proofer/pull/612) ([gjtorikian](https://github.com/gjtorikian))

## [v3.18.1](https://github.com/gjtorikian/html-proofer/tree/v3.18.1) (2020-12-16)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.18.0...v3.18.1)

**Closed issues:**

- Incorrect error on internal hash reference [\#607](https://github.com/gjtorikian/html-proofer/issues/607)

**Merged pull requests:**

- Fix inner hash check regression [\#610](https://github.com/gjtorikian/html-proofer/pull/610) ([gjtorikian](https://github.com/gjtorikian))

## [v3.18.0](https://github.com/gjtorikian/html-proofer/tree/v3.18.0) (2020-12-11)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.17.4...v3.18.0)

**Closed issues:**

- Ugly runtime error when broken links exist [\#608](https://github.com/gjtorikian/html-proofer/issues/608)

**Merged pull requests:**

- Never needed to raise [\#609](https://github.com/gjtorikian/html-proofer/pull/609) ([gjtorikian](https://github.com/gjtorikian))

## [v3.17.4](https://github.com/gjtorikian/html-proofer/tree/v3.17.4) (2020-12-03)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.17.3...v3.17.4)

**Closed issues:**

- NoMethodError: undefined method `link' [\#604](https://github.com/gjtorikian/html-proofer/issues/604)

**Merged pull requests:**

- Correct internal links when pulled from outdated cache [\#605](https://github.com/gjtorikian/html-proofer/pull/605) ([gjtorikian](https://github.com/gjtorikian))

## [v3.17.3](https://github.com/gjtorikian/html-proofer/tree/v3.17.3) (2020-11-28)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.17.2...v3.17.3)

**Closed issues:**

- Broken links to internal hash reported for wrong file \(3.17.0+\) [\#602](https://github.com/gjtorikian/html-proofer/issues/602)
- Updating from version 3.16.0 to 3.17.1 and all internal links fail to validate [\#601](https://github.com/gjtorikian/html-proofer/issues/601)
- 3.17.1 broke something [\#595](https://github.com/gjtorikian/html-proofer/issues/595)

**Merged pull requests:**

- Broken hash reporting [\#603](https://github.com/gjtorikian/html-proofer/pull/603) ([gjtorikian](https://github.com/gjtorikian))
- Try adding GitHub Actions lint [\#600](https://github.com/gjtorikian/html-proofer/pull/600) ([gjtorikian](https://github.com/gjtorikian))

## [v3.17.2](https://github.com/gjtorikian/html-proofer/tree/v3.17.2) (2020-11-23)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.17.1...v3.17.2)

**Merged pull requests:**

- Try using GitHub Actions [\#599](https://github.com/gjtorikian/html-proofer/pull/599) ([gjtorikian](https://github.com/gjtorikian))
- Fix internal link handling for dirs w/o root\_dir [\#597](https://github.com/gjtorikian/html-proofer/pull/597) ([gjtorikian](https://github.com/gjtorikian))
- CI: Drop unused Travis directive sudo: false [\#596](https://github.com/gjtorikian/html-proofer/pull/596) ([olleolleolle](https://github.com/olleolleolle))

## [v3.17.1](https://github.com/gjtorikian/html-proofer/tree/v3.17.1) (2020-11-22)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.17.0...v3.17.1)

**Closed issues:**

- root-folder option when HTMLProofer to run on a directory [\#587](https://github.com/gjtorikian/html-proofer/issues/587)

**Merged pull requests:**

- Let `root_dir` work when running on directories [\#594](https://github.com/gjtorikian/html-proofer/pull/594) ([gjtorikian](https://github.com/gjtorikian))

## [v3.17.0](https://github.com/gjtorikian/html-proofer/tree/v3.17.0) (2020-11-14)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.16.0...v3.17.0)

**Closed issues:**

- URLs in \<source src=xx\> not being checked. [\#589](https://github.com/gjtorikian/html-proofer/issues/589)
- Link checking failed with "441 No error" [\#584](https://github.com/gjtorikian/html-proofer/issues/584)
- htmlproofer 3.16.0 | Error:  undefined method `match?' for /^javascript:/:Regexp [\#582](https://github.com/gjtorikian/html-proofer/issues/582)
- HTMLProofer runs out of memory [\#579](https://github.com/gjtorikian/html-proofer/issues/579)

**Merged pull requests:**

- lint [\#592](https://github.com/gjtorikian/html-proofer/pull/592) ([gjtorikian](https://github.com/gjtorikian))
- test source tags [\#591](https://github.com/gjtorikian/html-proofer/pull/591) ([gjtorikian](https://github.com/gjtorikian))
- support cache for internal links [\#590](https://github.com/gjtorikian/html-proofer/pull/590) ([gjtorikian](https://github.com/gjtorikian))
- Replaced reccomanded Docker image [\#586](https://github.com/gjtorikian/html-proofer/pull/586) ([iBobik](https://github.com/iBobik))

## [v3.16.0](https://github.com/gjtorikian/html-proofer/tree/v3.16.0) (2020-09-11)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.15.3...v3.16.0)

**Closed issues:**

- data-proofer-ignore not helping to filter out error about `@click` anchor attribute [\#576](https://github.com/gjtorikian/html-proofer/issues/576)
- Allow for not checking all URLs [\#571](https://github.com/gjtorikian/html-proofer/issues/571)
- Identy theft [\#569](https://github.com/gjtorikian/html-proofer/issues/569)
- Identy theft [\#568](https://github.com/gjtorikian/html-proofer/issues/568)
- error after moving from 3.11.1 to 3.15.3 [\#562](https://github.com/gjtorikian/html-proofer/issues/562)
- Can't install html-proofer with ruby v2.7 [\#561](https://github.com/gjtorikian/html-proofer/issues/561)
- Add ability to customize the output to hook into reporting tools [\#516](https://github.com/gjtorikian/html-proofer/issues/516)
- Reported results are not consistent  [\#485](https://github.com/gjtorikian/html-proofer/issues/485)
- 403 on  https://www.oracle.com domain with Travis only [\#483](https://github.com/gjtorikian/html-proofer/issues/483)
- add option to check only unique links [\#473](https://github.com/gjtorikian/html-proofer/issues/473)
- Standardize output format, use STAT format [\#387](https://github.com/gjtorikian/html-proofer/issues/387)
- Allow Typheous options to be set from `bin`/command line [\#379](https://github.com/gjtorikian/html-proofer/issues/379)
- Support links behind auth [\#86](https://github.com/gjtorikian/html-proofer/issues/86)

**Merged pull requests:**

- Allow for at-signs [\#578](https://github.com/gjtorikian/html-proofer/pull/578) ([gjtorikian](https://github.com/gjtorikian))
- Add HTMLProofer::Runner\#before\_request [\#577](https://github.com/gjtorikian/html-proofer/pull/577) ([asbjornu](https://github.com/asbjornu))

## [v3.15.3](https://github.com/gjtorikian/html-proofer/tree/v3.15.3) (2020-04-20)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.15.2...v3.15.3)

**Merged pull requests:**

- Fix recheck of failures whith caching [\#556](https://github.com/gjtorikian/html-proofer/pull/556) ([riccardoporreca](https://github.com/riccardoporreca))

## [v3.15.2](https://github.com/gjtorikian/html-proofer/tree/v3.15.2) (2020-03-26)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.15.1...v3.15.2)

**Closed issues:**

- invalid attribute name `;' \(NameError\) [\#559](https://github.com/gjtorikian/html-proofer/issues/559)
- Document how to run test suite [\#557](https://github.com/gjtorikian/html-proofer/issues/557)
- Add expect-failing html test cases [\#553](https://github.com/gjtorikian/html-proofer/issues/553)
- I'm looking for maintainers! [\#422](https://github.com/gjtorikian/html-proofer/issues/422)

**Merged pull requests:**

- Leave semicolon attr [\#560](https://github.com/gjtorikian/html-proofer/pull/560) ([gjtorikian](https://github.com/gjtorikian))
- Add tests demonstrating parse failure [\#555](https://github.com/gjtorikian/html-proofer/pull/555) ([gjtorikian](https://github.com/gjtorikian))
- Minor grammar fix [\#551](https://github.com/gjtorikian/html-proofer/pull/551) ([dsinn](https://github.com/dsinn))

## [v3.15.1](https://github.com/gjtorikian/html-proofer/tree/v3.15.1) (2020-01-20)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.15.0...v3.15.1)

**Fixed bugs:**

- html-proofer failed to pick up html validation errors [\#526](https://github.com/gjtorikian/html-proofer/issues/526)

**Closed issues:**

- HTML Proofer report is not displayed on Ruby 2.7 [\#549](https://github.com/gjtorikian/html-proofer/issues/549)
- NameError: invalid attribute name `charlie""' [\#548](https://github.com/gjtorikian/html-proofer/issues/548)
- html-proofer failed to pick up html validation errors [\#547](https://github.com/gjtorikian/html-proofer/issues/547)
- Is it possible to weaken the nokogumbo dependency to version 1.4 and above? [\#546](https://github.com/gjtorikian/html-proofer/issues/546)

**Merged pull requests:**

- Fix mysterious new ruby issues [\#550](https://github.com/gjtorikian/html-proofer/pull/550) ([gjtorikian](https://github.com/gjtorikian))

## [v3.15.0](https://github.com/gjtorikian/html-proofer/tree/v3.15.0) (2019-12-13)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.14.1...v3.15.0)

**Closed issues:**

- Replace Nokogiri with something that validates HTML5 [\#318](https://github.com/gjtorikian/html-proofer/issues/318)

**Merged pull requests:**

- HTML5 parsing and error checking [\#362](https://github.com/gjtorikian/html-proofer/pull/362) ([jeremy](https://github.com/jeremy))

## [v3.14.1](https://github.com/gjtorikian/html-proofer/tree/v3.14.1) (2019-11-17)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.14.0...v3.14.1)

**Closed issues:**

- Error:  undefined method `xpath' for nil:NilClass [\#544](https://github.com/gjtorikian/html-proofer/issues/544)

**Merged pull requests:**

- Fix: internal hash links [\#545](https://github.com/gjtorikian/html-proofer/pull/545) ([gjtorikian](https://github.com/gjtorikian))

## [v3.14.0](https://github.com/gjtorikian/html-proofer/tree/v3.14.0) (2019-11-17)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.13.0...v3.14.0)

**Closed issues:**

- command line ssl\_verifypeer false [\#194](https://github.com/gjtorikian/html-proofer/issues/194)

**Merged pull requests:**

- refactor: use internal instead of not external [\#541](https://github.com/gjtorikian/html-proofer/pull/541) ([Graborg](https://github.com/Graborg))
- feat: enable specifying a root folder [\#540](https://github.com/gjtorikian/html-proofer/pull/540) ([Graborg](https://github.com/Graborg))
- Fix: internal link misrepresented and misused [\#539](https://github.com/gjtorikian/html-proofer/pull/539) ([Graborg](https://github.com/Graborg))

## [v3.13.0](https://github.com/gjtorikian/html-proofer/tree/v3.13.0) (2019-09-25)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.12.2...v3.13.0)

**Closed issues:**

- Possible bug: htmlParseEntityRef: expecting ';' for ampersand in URLs [\#537](https://github.com/gjtorikian/html-proofer/issues/537)

**Merged pull requests:**

- Allow accessing list of issues directly [\#538](https://github.com/gjtorikian/html-proofer/pull/538) ([muan](https://github.com/muan))

## [v3.12.2](https://github.com/gjtorikian/html-proofer/tree/v3.12.2) (2019-09-07)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.12.1...v3.12.2)

**Merged pull requests:**

- Check only stylesheet link rels rather than whitelisting other rels [\#529](https://github.com/gjtorikian/html-proofer/pull/529) ([Floppy](https://github.com/Floppy))

## [v3.12.1](https://github.com/gjtorikian/html-proofer/tree/v3.12.1) (2019-09-07)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.12.0...v3.12.1)

**Closed issues:**

- Timerizer dependency conflicts with ActiveSupport [\#535](https://github.com/gjtorikian/html-proofer/issues/535)

**Merged pull requests:**

- Do time duration yourself [\#536](https://github.com/gjtorikian/html-proofer/pull/536) ([gjtorikian](https://github.com/gjtorikian))

## [v3.12.0](https://github.com/gjtorikian/html-proofer/tree/v3.12.0) (2019-09-03)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.11.1...v3.12.0)

**Closed issues:**

- internal links as external [\#532](https://github.com/gjtorikian/html-proofer/issues/532)
- question: How do i force html proofer to check for broken image links locally within a github PR on travis - external link failed [\#527](https://github.com/gjtorikian/html-proofer/issues/527)
- OpenGraphCheck fails to check og:image [\#510](https://github.com/gjtorikian/html-proofer/issues/510)

**Merged pull requests:**

- Remove ActiveRecord requirement [\#534](https://github.com/gjtorikian/html-proofer/pull/534) ([gjtorikian](https://github.com/gjtorikian))

## [v3.11.1](https://github.com/gjtorikian/html-proofer/tree/v3.11.1) (2019-07-17)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.11.0...v3.11.1)

**Closed issues:**

- Support User-Agent calling external link with command line  [\#524](https://github.com/gjtorikian/html-proofer/issues/524)

**Merged pull requests:**

- Don't set blank hash values [\#525](https://github.com/gjtorikian/html-proofer/pull/525) ([gjtorikian](https://github.com/gjtorikian))
- Fix typo in README.md [\#522](https://github.com/gjtorikian/html-proofer/pull/522) ([abahgat](https://github.com/abahgat))

## [v3.11.0](https://github.com/gjtorikian/html-proofer/tree/v3.11.0) (2019-06-16)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.10.2...v3.11.0)

**Fixed bugs:**

- file-ignore not ignoring properly [\#459](https://github.com/gjtorikian/html-proofer/issues/459)

**Closed issues:**

- Add ability to only check one of internal/external links [\#517](https://github.com/gjtorikian/html-proofer/issues/517)
- Using html-proofer on collections of Jekyll posts [\#515](https://github.com/gjtorikian/html-proofer/issues/515)
- PRE blocks ignored [\#514](https://github.com/gjtorikian/html-proofer/issues/514)
- Strange failure [\#513](https://github.com/gjtorikian/html-proofer/issues/513)
- Checks external hashes fails for GitHub code snippets [\#511](https://github.com/gjtorikian/html-proofer/issues/511)
- Different results in production [\#508](https://github.com/gjtorikian/html-proofer/issues/508)
- False positives on img with new lines on src value [\#506](https://github.com/gjtorikian/html-proofer/issues/506)

**Merged pull requests:**

- Adds missing .run to check\_links [\#520](https://github.com/gjtorikian/html-proofer/pull/520) ([esasse](https://github.com/esasse))
- Switch coloring gems [\#519](https://github.com/gjtorikian/html-proofer/pull/519) ([gjtorikian](https://github.com/gjtorikian))
- Check GitHub file link [\#518](https://github.com/gjtorikian/html-proofer/pull/518) ([gjtorikian](https://github.com/gjtorikian))
- Add rack middleware for proofing HTML at runtime [\#512](https://github.com/gjtorikian/html-proofer/pull/512) ([DanielHeath](https://github.com/DanielHeath))

## [v3.10.2](https://github.com/gjtorikian/html-proofer/tree/v3.10.2) (2019-01-19)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.10.1...v3.10.2)

## [v3.10.1](https://github.com/gjtorikian/html-proofer/tree/v3.10.1) (2019-01-16)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.10.0...v3.10.1)

**Closed issues:**

- Redundant mandatory argument for "--as-links" option [\#504](https://github.com/gjtorikian/html-proofer/issues/504)

**Merged pull requests:**

- Tweak `--as-links` cli [\#505](https://github.com/gjtorikian/html-proofer/pull/505) ([gjtorikian](https://github.com/gjtorikian))

## [v3.10.0](https://github.com/gjtorikian/html-proofer/tree/v3.10.0) (2019-01-04)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.9.3...v3.10.0)

**Implemented enhancements:**

- Add support for Open Graph entries [\#494](https://github.com/gjtorikian/html-proofer/issues/494)

**Closed issues:**

- assume\_extension fails when a directory with the same name as a file exists [\#502](https://github.com/gjtorikian/html-proofer/issues/502)
- SRI and CORS errors in \<link\> tag where they shouldn't be [\#495](https://github.com/gjtorikian/html-proofer/issues/495)

**Merged pull requests:**

- Make assume\_extension work with a directory with the same name [\#503](https://github.com/gjtorikian/html-proofer/pull/503) ([nex3](https://github.com/nex3))
- Let Travis build with ruby 2.6.0 [\#501](https://github.com/gjtorikian/html-proofer/pull/501) ([sschiffer](https://github.com/sschiffer))
- Ignoring sri for pagination rels  [\#499](https://github.com/gjtorikian/html-proofer/pull/499) ([vllur](https://github.com/vllur))
- Support Typhoeus options from command line [\#490](https://github.com/gjtorikian/html-proofer/pull/490) ([SeanKilleen](https://github.com/SeanKilleen))

## [v3.9.3](https://github.com/gjtorikian/html-proofer/tree/v3.9.3) (2018-11-28)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.9.2...v3.9.3)

**Closed issues:**

- Links being changed causing hash to not be found [\#497](https://github.com/gjtorikian/html-proofer/issues/497)
- Checking anchors isn't working for me [\#493](https://github.com/gjtorikian/html-proofer/issues/493)
- Is it possible to map an external URL pattern to make it appear local? [\#489](https://github.com/gjtorikian/html-proofer/issues/489)
- Getting "external link" errors on an internal link [\#488](https://github.com/gjtorikian/html-proofer/issues/488)
- build error according to the readme badge [\#487](https://github.com/gjtorikian/html-proofer/issues/487)
- Unicode domains cannot be processed [\#480](https://github.com/gjtorikian/html-proofer/issues/480)

**Merged pull requests:**

- Check hash capitals [\#498](https://github.com/gjtorikian/html-proofer/pull/498) ([gjtorikian](https://github.com/gjtorikian))
- Keep rubocop happy [\#491](https://github.com/gjtorikian/html-proofer/pull/491) ([gjtorikian](https://github.com/gjtorikian))
- Support/test unicode/punnycode domains [\#486](https://github.com/gjtorikian/html-proofer/pull/486) ([gjtorikian](https://github.com/gjtorikian))

## [v3.9.2](https://github.com/gjtorikian/html-proofer/tree/v3.9.2) (2018-08-01)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.9.1...v3.9.2)

**Fixed bugs:**

- SRI and CORS should not report an error for favicon. [\#481](https://github.com/gjtorikian/html-proofer/issues/481)

**Closed issues:**

- Counting error in HTML proofer. [\#466](https://github.com/gjtorikian/html-proofer/issues/466)

**Merged pull requests:**

-  Add more skippable rel types [\#484](https://github.com/gjtorikian/html-proofer/pull/484) ([gjtorikian](https://github.com/gjtorikian))
- Changed description of allow\_hash\_href option [\#479](https://github.com/gjtorikian/html-proofer/pull/479) ([iBobik](https://github.com/iBobik))
- Remove trailing whitespaces [\#478](https://github.com/gjtorikian/html-proofer/pull/478) ([LuizHAssuncao](https://github.com/LuizHAssuncao))

## [v3.9.1](https://github.com/gjtorikian/html-proofer/tree/v3.9.1) (2018-05-28)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.9.0...v3.9.1)

**Closed issues:**

- ArgumentError: invalid byte sequence in US-ASCII [\#476](https://github.com/gjtorikian/html-proofer/issues/476)

**Merged pull requests:**

- don't File.read directories [\#477](https://github.com/gjtorikian/html-proofer/pull/477) ([adamdecaf](https://github.com/adamdecaf))

## [v3.9.0](https://github.com/gjtorikian/html-proofer/tree/v3.9.0) (2018-05-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.8.0...v3.9.0)

**Fixed bugs:**

- Invalid URL error [\#465](https://github.com/gjtorikian/html-proofer/issues/465)

**Closed issues:**

- Add an option for allowing to omit a href on anchors\(for .html.erb extension\) [\#474](https://github.com/gjtorikian/html-proofer/issues/474)

**Merged pull requests:**

- Allow skipping the `href` requirement [\#475](https://github.com/gjtorikian/html-proofer/pull/475) ([gjtorikian](https://github.com/gjtorikian))
- change cop name [\#472](https://github.com/gjtorikian/html-proofer/pull/472) ([stephengroat](https://github.com/stephengroat))
- \[CI\] Test against Ruby 2.5 [\#470](https://github.com/gjtorikian/html-proofer/pull/470) ([nicolasleger](https://github.com/nicolasleger))
- Improve / Fix Example Code in README [\#469](https://github.com/gjtorikian/html-proofer/pull/469) ([nkuehn](https://github.com/nkuehn))

## [v3.8.0](https://github.com/gjtorikian/html-proofer/tree/v3.8.0) (2018-01-05)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.7.6...v3.8.0)

**Merged pull requests:**

- dropping url.chomp\('/'\) which cause 301s [\#462](https://github.com/gjtorikian/html-proofer/pull/462) ([ldemailly](https://github.com/ldemailly))
- Remove chomp URL from debug output [\#398](https://github.com/gjtorikian/html-proofer/pull/398) ([mattclegg](https://github.com/mattclegg))

## [v3.7.6](https://github.com/gjtorikian/html-proofer/tree/v3.7.6) (2017-12-18)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.7.5...v3.7.6)

**Merged pull requests:**

- Update nokogiri to ~\> 1.8.1 \(CVE-2017-9050\) [\#464](https://github.com/gjtorikian/html-proofer/pull/464) ([theneva](https://github.com/theneva))

## [v3.7.5](https://github.com/gjtorikian/html-proofer/tree/v3.7.5) (2017-11-28)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.7.4...v3.7.5)

**Closed issues:**

- Possible regression: htmlParseEntityRef: expecting ';' for protocol relative URLs [\#447](https://github.com/gjtorikian/html-proofer/issues/447)
- HEAD to GET fallback doesn't work if URL has a hash and HEAD causes a timeout [\#441](https://github.com/gjtorikian/html-proofer/issues/441)
- Allow using GET instead of HEAD [\#440](https://github.com/gjtorikian/html-proofer/issues/440)
- Error:  wrong number of arguments [\#430](https://github.com/gjtorikian/html-proofer/issues/430)
- limit memory for travis builds [\#429](https://github.com/gjtorikian/html-proofer/issues/429)

**Merged pull requests:**

- Adjust regex to account for protocol-less links [\#461](https://github.com/gjtorikian/html-proofer/pull/461) ([gjtorikian](https://github.com/gjtorikian))

## [v3.7.4](https://github.com/gjtorikian/html-proofer/tree/v3.7.4) (2017-10-07)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.7.3...v3.7.4)

**Fixed bugs:**

- Error:  string contains null byte [\#409](https://github.com/gjtorikian/html-proofer/issues/409)

**Closed issues:**

- SRI need not be checked for rel="canonical" and rel="alternate" links [\#457](https://github.com/gjtorikian/html-proofer/issues/457)
- Permission denied @ rb\_sysopen [\#456](https://github.com/gjtorikian/html-proofer/issues/456)
- Release 3.7.3 [\#450](https://github.com/gjtorikian/html-proofer/issues/450)
- SSL link check fails, while curl succeeds [\#376](https://github.com/gjtorikian/html-proofer/issues/376)

**Merged pull requests:**

- SRI need not be checked for rel=canonical and rel=alternate links [\#458](https://github.com/gjtorikian/html-proofer/pull/458) ([ilyalyo](https://github.com/ilyalyo))
- Add code owners file [\#455](https://github.com/gjtorikian/html-proofer/pull/455) ([Floppy](https://github.com/Floppy))
- Replace null chars with empty ones [\#454](https://github.com/gjtorikian/html-proofer/pull/454) ([ilyalyo](https://github.com/ilyalyo))

## [v3.7.3](https://github.com/gjtorikian/html-proofer/tree/v3.7.3) (2017-09-22)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.7.2...v3.7.3)

**Closed issues:**

- Replaced 'colored' with 'colorize' [\#449](https://github.com/gjtorikian/html-proofer/issues/449)
- Favicon checks and redirect pages [\#446](https://github.com/gjtorikian/html-proofer/issues/446)
- Sri Cors checks 'a' tag [\#442](https://github.com/gjtorikian/html-proofer/issues/442)
- Link checker does not fallback to GET when a HEAD request times out [\#439](https://github.com/gjtorikian/html-proofer/issues/439)
- Add option to warn about absolute internal URLs ? [\#436](https://github.com/gjtorikian/html-proofer/issues/436)
- Set the timeout value from the commandline. [\#435](https://github.com/gjtorikian/html-proofer/issues/435)
- Add rubocop rules [\#423](https://github.com/gjtorikian/html-proofer/issues/423)
- Invalid hash check [\#419](https://github.com/gjtorikian/html-proofer/issues/419)
- empty\_alt\_ignore option doesn't do anything [\#416](https://github.com/gjtorikian/html-proofer/issues/416)

**Merged pull requests:**

- Fix the `empty_alt_ignore` option [\#453](https://github.com/gjtorikian/html-proofer/pull/453) ([gjtorikian](https://github.com/gjtorikian))
- More robust redirect detection [\#452](https://github.com/gjtorikian/html-proofer/pull/452) ([Floppy](https://github.com/Floppy))
- Change to use colorize gem [\#451](https://github.com/gjtorikian/html-proofer/pull/451) ([Floppy](https://github.com/Floppy))
- Ignore Jekyll redirect\_from template from favicon check [\#448](https://github.com/gjtorikian/html-proofer/pull/448) ([gjtorikian](https://github.com/gjtorikian))
- Send a sensible Accept header when testing external links [\#445](https://github.com/gjtorikian/html-proofer/pull/445) ([timrogers](https://github.com/timrogers))
- This is a closed repo now [\#444](https://github.com/gjtorikian/html-proofer/pull/444) ([gjtorikian](https://github.com/gjtorikian))
- check only 'link' tag links [\#443](https://github.com/gjtorikian/html-proofer/pull/443) ([ilyalyo](https://github.com/ilyalyo))
- Codecov and timeout test [\#438](https://github.com/gjtorikian/html-proofer/pull/438) ([stephengroat](https://github.com/stephengroat))

## [v3.7.2](https://github.com/gjtorikian/html-proofer/tree/v3.7.2) (2017-05-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.7.1...v3.7.2)

## [v3.7.1](https://github.com/gjtorikian/html-proofer/tree/v3.7.1) (2017-05-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.7.0...v3.7.1)

**Merged pull requests:**

- Fix some tests [\#434](https://github.com/gjtorikian/html-proofer/pull/434) ([gjtorikian](https://github.com/gjtorikian))

## [v3.7.0](https://github.com/gjtorikian/html-proofer/tree/v3.7.0) (2017-05-20)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.6.0...v3.7.0)

**Closed issues:**

- Enable project wiki [\#427](https://github.com/gjtorikian/html-proofer/issues/427)
- \[feature request\] Config option to ignore certain HTTP errors [\#426](https://github.com/gjtorikian/html-proofer/issues/426)
- Favicon check failing on Ruby built from Docker. [\#425](https://github.com/gjtorikian/html-proofer/issues/425)
- Any way to add wildcards to --url-ignore in the command line? [\#418](https://github.com/gjtorikian/html-proofer/issues/418)
- Documentation for external checker [\#415](https://github.com/gjtorikian/html-proofer/issues/415)
- Check for SRI/CORS in CSS files [\#406](https://github.com/gjtorikian/html-proofer/issues/406)
- SRI/CORS check should ignore relative links [\#400](https://github.com/gjtorikian/html-proofer/issues/400)
- README.md has incorrect path to cache log file [\#397](https://github.com/gjtorikian/html-proofer/issues/397)
- Multiple --url-ignore [\#377](https://github.com/gjtorikian/html-proofer/issues/377)
- Invalid hash check is wrong for other pages + aria-hidden not supported [\#367](https://github.com/gjtorikian/html-proofer/issues/367)
- WCAG 2.0 validation [\#366](https://github.com/gjtorikian/html-proofer/issues/366)
- Scheme-less image links should always pass validation [\#363](https://github.com/gjtorikian/html-proofer/issues/363)
- crawling sites [\#334](https://github.com/gjtorikian/html-proofer/issues/334)
- Add an option to test links for an HTTPS alternative [\#314](https://github.com/gjtorikian/html-proofer/issues/314)
- Do twice check on HTTP error [\#310](https://github.com/gjtorikian/html-proofer/issues/310)
- HTML-Proofer should follow clientside redirects [\#208](https://github.com/gjtorikian/html-proofer/issues/208)
- Content negotiation [\#108](https://github.com/gjtorikian/html-proofer/issues/108)
- External embeds [\#57](https://github.com/gjtorikian/html-proofer/issues/57)

**Merged pull requests:**

- Document difference between command line and Ruby implementation [\#433](https://github.com/gjtorikian/html-proofer/pull/433) ([fulldecent](https://github.com/fulldecent))
- Add reference to Project Calico docs build [\#432](https://github.com/gjtorikian/html-proofer/pull/432) ([tomdee](https://github.com/tomdee))
- Add some words on project scope [\#428](https://github.com/gjtorikian/html-proofer/pull/428) ([gjtorikian](https://github.com/gjtorikian))
- Test that links referencing itself works [\#424](https://github.com/gjtorikian/html-proofer/pull/424) ([gjtorikian](https://github.com/gjtorikian))
- support links to the \#top of pages [\#421](https://github.com/gjtorikian/html-proofer/pull/421) ([afeld](https://github.com/afeld))
- handle base without href [\#420](https://github.com/gjtorikian/html-proofer/pull/420) ([mlinksva](https://github.com/mlinksva))
- Update nokogiri to v1.7 [\#414](https://github.com/gjtorikian/html-proofer/pull/414) ([gemfarmer](https://github.com/gemfarmer))
- Check for SRI/CORS in CSS files [\#413](https://github.com/gjtorikian/html-proofer/pull/413) ([ilyalyo](https://github.com/ilyalyo))
- SRI/CORS check should ignore relative links [\#412](https://github.com/gjtorikian/html-proofer/pull/412) ([ilyalyo](https://github.com/ilyalyo))

## [v3.6.0](https://github.com/gjtorikian/html-proofer/tree/v3.6.0) (2017-03-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.5.0...v3.6.0)

**Closed issues:**

- Configurable HTMLProofer::Utils::STORAGE\_DIR? [\#369](https://github.com/gjtorikian/html-proofer/issues/369)

**Merged pull requests:**

- Slight test updates [\#410](https://github.com/gjtorikian/html-proofer/pull/410) ([gjtorikian](https://github.com/gjtorikian))
- Set Typhoeus connection timeout, fixes \#231, fixes \#340 [\#407](https://github.com/gjtorikian/html-proofer/pull/407) ([fulldecent](https://github.com/fulldecent))
- Include HTML Website Template as a real-life example [\#404](https://github.com/gjtorikian/html-proofer/pull/404) ([fulldecent](https://github.com/fulldecent))
- Correct capitalization [\#403](https://github.com/gjtorikian/html-proofer/pull/403) ([fulldecent](https://github.com/fulldecent))
- Yell documentation is not helpful, inline needed information [\#402](https://github.com/gjtorikian/html-proofer/pull/402) ([fulldecent](https://github.com/fulldecent))
- Escape quotes in anchors [\#401](https://github.com/gjtorikian/html-proofer/pull/401) ([henri-tremblay](https://github.com/henri-tremblay))
- Update README.md to reflect correct cache.log path [\#396](https://github.com/gjtorikian/html-proofer/pull/396) ([sjauld](https://github.com/sjauld))
- Make cache storage directory configurable [\#395](https://github.com/gjtorikian/html-proofer/pull/395) ([tisba](https://github.com/tisba))

## [v3.5.0](https://github.com/gjtorikian/html-proofer/tree/v3.5.0) (2017-03-04)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.4.0...v3.5.0)

**Implemented enhancements:**

- Add testing on UrlValidator [\#164](https://github.com/gjtorikian/html-proofer/issues/164)

**Closed issues:**

- False positive on \<link rel="dns-prefetch"\> [\#389](https://github.com/gjtorikian/html-proofer/issues/389)
- Catch Double Forward Slashes in the URL Path [\#386](https://github.com/gjtorikian/html-proofer/issues/386)
- Proofer falsely reports failure for CGI-escaped URLs [\#385](https://github.com/gjtorikian/html-proofer/issues/385)
- Check that `<link>` and `<script>` external resources do use SRI [\#382](https://github.com/gjtorikian/html-proofer/issues/382)
- Provide complete example of using caching on CI [\#381](https://github.com/gjtorikian/html-proofer/issues/381)
- Depends on development dependencies [\#380](https://github.com/gjtorikian/html-proofer/issues/380)
- --url-ignore matching [\#378](https://github.com/gjtorikian/html-proofer/issues/378)
- Command line flags are slightly different compared to ruby config [\#374](https://github.com/gjtorikian/html-proofer/issues/374)
- HTMLProofer loaded twice? [\#371](https://github.com/gjtorikian/html-proofer/issues/371)
- data-proofer-ignore does not work on a parent element [\#370](https://github.com/gjtorikian/html-proofer/issues/370)
- Relative links from index.html should fail [\#348](https://github.com/gjtorikian/html-proofer/issues/348)
- Ignore "no error" [\#336](https://github.com/gjtorikian/html-proofer/issues/336)
- Multiple values for directory\_index\_file [\#195](https://github.com/gjtorikian/html-proofer/issues/195)

**Merged pull requests:**

- Only normalize a URL when it is actually needed [\#394](https://github.com/gjtorikian/html-proofer/pull/394) ([gjtorikian](https://github.com/gjtorikian))
- Ensure lack of slash in error messages [\#393](https://github.com/gjtorikian/html-proofer/pull/393) ([gjtorikian](https://github.com/gjtorikian))
- Let the parent element mark the ignorability of content [\#392](https://github.com/gjtorikian/html-proofer/pull/392) ([gjtorikian](https://github.com/gjtorikian))
- Add Travis CI caching example [\#391](https://github.com/gjtorikian/html-proofer/pull/391) ([gjtorikian](https://github.com/gjtorikian))
- Skip DNS prefetch links for now [\#390](https://github.com/gjtorikian/html-proofer/pull/390) ([gjtorikian](https://github.com/gjtorikian))
- Check for SRI/CORS links \#382 [\#388](https://github.com/gjtorikian/html-proofer/pull/388) ([ilyalyo](https://github.com/ilyalyo))
- Explain how people are implementing htmlproofer in the examples [\#384](https://github.com/gjtorikian/html-proofer/pull/384) ([fulldecent](https://github.com/fulldecent))
- Add link to "documentation" for command line options [\#383](https://github.com/gjtorikian/html-proofer/pull/383) ([fulldecent](https://github.com/fulldecent))
- \#374 for more clarity for CLI flags [\#375](https://github.com/gjtorikian/html-proofer/pull/375) ([VirenMohindra](https://github.com/VirenMohindra))
- test url maybe once obtained 406, now 404 [\#373](https://github.com/gjtorikian/html-proofer/pull/373) ([mlinksva](https://github.com/mlinksva))
- Add check\_img\_http to README [\#372](https://github.com/gjtorikian/html-proofer/pull/372) ([mlinksva](https://github.com/mlinksva))

## [v3.4.0](https://github.com/gjtorikian/html-proofer/tree/v3.4.0) (2016-12-16)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.3.1...v3.4.0)

**Closed issues:**

- Twitter Cards tags get flagged as erroneous [\#365](https://github.com/gjtorikian/html-proofer/issues/365)
- .html extension not respected by html-proofer [\#364](https://github.com/gjtorikian/html-proofer/issues/364)

**Merged pull requests:**

- Improvements to html-proofer: [\#368](https://github.com/gjtorikian/html-proofer/pull/368) ([jeznag](https://github.com/jeznag))

## [v3.3.1](https://github.com/gjtorikian/html-proofer/tree/v3.3.1) (2016-10-20)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.3.0...v3.3.1)

**Merged pull requests:**

- Provide the Open Graph src URL by inheritance so internal-domains work [\#361](https://github.com/gjtorikian/html-proofer/pull/361) ([peternewman](https://github.com/peternewman))
- Correct internal\_domains hyphenation to an underscore [\#360](https://github.com/gjtorikian/html-proofer/pull/360) ([peternewman](https://github.com/peternewman))

## [v3.3.0](https://github.com/gjtorikian/html-proofer/tree/v3.3.0) (2016-10-07)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.2.0...v3.3.0)

**Closed issues:**

- How tu use url\_ignore in command line? [\#333](https://github.com/gjtorikian/html-proofer/issues/333)
- Support Open Graph [\#111](https://github.com/gjtorikian/html-proofer/issues/111)

**Merged pull requests:**

- Implement Open Graph [\#359](https://github.com/gjtorikian/html-proofer/pull/359) ([peternewman](https://github.com/peternewman))

## [v3.2.0](https://github.com/gjtorikian/html-proofer/tree/v3.2.0) (2016-09-28)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.1.0...v3.2.0)

**Closed issues:**

- Travis build failing [\#357](https://github.com/gjtorikian/html-proofer/issues/357)
- More Working Examples of CLI Use [\#324](https://github.com/gjtorikian/html-proofer/issues/324)
- In case of failed check print more context [\#317](https://github.com/gjtorikian/html-proofer/issues/317)
- HTML base tag [\#166](https://github.com/gjtorikian/html-proofer/issues/166)

**Merged pull requests:**

- Add support for `base` element [\#358](https://github.com/gjtorikian/html-proofer/pull/358) ([gjtorikian](https://github.com/gjtorikian))
- Report on the content of the error, when able [\#356](https://github.com/gjtorikian/html-proofer/pull/356) ([gjtorikian](https://github.com/gjtorikian))

## [v3.1.0](https://github.com/gjtorikian/html-proofer/tree/v3.1.0) (2016-09-22)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.0.6...v3.1.0)

**Closed issues:**

- ActiveRecord 5 support?  [\#354](https://github.com/gjtorikian/html-proofer/issues/354)
- Array check in htmlproofer Line 51 [\#352](https://github.com/gjtorikian/html-proofer/issues/352)
- Add setting for "internal" domains [\#349](https://github.com/gjtorikian/html-proofer/issues/349)
- Travis and local runs of same version differ [\#347](https://github.com/gjtorikian/html-proofer/issues/347)
- Clarify install instructions [\#345](https://github.com/gjtorikian/html-proofer/issues/345)
- External links pointing to non-responsive servers cause stall [\#340](https://github.com/gjtorikian/html-proofer/issues/340)
- Checking for unused CSS [\#338](https://github.com/gjtorikian/html-proofer/issues/338)
- Checking for unused images [\#337](https://github.com/gjtorikian/html-proofer/issues/337)
- External Link test failing on Valid URL - ONLY on Travis server [\#331](https://github.com/gjtorikian/html-proofer/issues/331)
- Spell Check [\#330](https://github.com/gjtorikian/html-proofer/issues/330)
- --url-swap keys can't contain colon [\#293](https://github.com/gjtorikian/html-proofer/issues/293)

**Merged pull requests:**

- Support newer ActiveSupport [\#355](https://github.com/gjtorikian/html-proofer/pull/355) ([gjtorikian](https://github.com/gjtorikian))
- Add --internal-domains option [\#351](https://github.com/gjtorikian/html-proofer/pull/351) ([Roang-zero1](https://github.com/Roang-zero1))
- Use regex for colon escape [\#350](https://github.com/gjtorikian/html-proofer/pull/350) ([Roang-zero1](https://github.com/Roang-zero1))
- Add Atom Flight Manual to real-life examples [\#346](https://github.com/gjtorikian/html-proofer/pull/346) ([lee-dohm](https://github.com/lee-dohm))
- spelling fixes [\#342](https://github.com/gjtorikian/html-proofer/pull/342) ([ka7](https://github.com/ka7))
- Links point to webpages [\#339](https://github.com/gjtorikian/html-proofer/pull/339) ([fulldecent](https://github.com/fulldecent))
- link to html-proofer-docker [\#335](https://github.com/gjtorikian/html-proofer/pull/335) ([afeld](https://github.com/afeld))
- Added escape sequences for --url-swap [\#320](https://github.com/gjtorikian/html-proofer/pull/320) ([johnzeringue](https://github.com/johnzeringue))

## [v3.0.6](https://github.com/gjtorikian/html-proofer/tree/v3.0.6) (2016-05-17)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.0.5...v3.0.6)

**Closed issues:**

- htmlParseEntityRef errors with lone "&" [\#328](https://github.com/gjtorikian/html-proofer/issues/328)
- Rakefile for Jekyll uninitialized constant HTMLProofer [\#326](https://github.com/gjtorikian/html-proofer/issues/326)

**Merged pull requests:**

- Do not blow up on missing ampersand names [\#332](https://github.com/gjtorikian/html-proofer/pull/332) ([gjtorikian](https://github.com/gjtorikian))
- Text update of Nokogiri hyperlink [\#329](https://github.com/gjtorikian/html-proofer/pull/329) ([pranavgoel25](https://github.com/pranavgoel25))
- Properly ignore alt without ignoring image [\#327](https://github.com/gjtorikian/html-proofer/pull/327) ([arvindsv](https://github.com/arvindsv))

## [v3.0.5](https://github.com/gjtorikian/html-proofer/tree/v3.0.5) (2016-04-01)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.0.4...v3.0.5)

**Closed issues:**

- Valid URL failing validation [\#323](https://github.com/gjtorikian/html-proofer/issues/323)
- External link failed: response code 0 means something's wrong [\#321](https://github.com/gjtorikian/html-proofer/issues/321)

**Merged pull requests:**

- Sanitize links with invisible `\u200B` characters [\#325](https://github.com/gjtorikian/html-proofer/pull/325) ([gjtorikian](https://github.com/gjtorikian))
- Show return message for status code 0 [\#322](https://github.com/gjtorikian/html-proofer/pull/322) ([mlinksva](https://github.com/mlinksva))
- htmlproofer should set status codes to ints [\#319](https://github.com/gjtorikian/html-proofer/pull/319) ([parkr](https://github.com/parkr))

## [v3.0.4](https://github.com/gjtorikian/html-proofer/tree/v3.0.4) (2016-03-10)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.0.3...v3.0.4)

**Closed issues:**

- Build not works afer 3.0.3  [\#316](https://github.com/gjtorikian/html-proofer/issues/316)
- Lots of noise, unclear how to quiet [\#315](https://github.com/gjtorikian/html-proofer/issues/315)

## [v3.0.3](https://github.com/gjtorikian/html-proofer/tree/v3.0.3) (2016-03-07)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.0.2...v3.0.3)

## [v3.0.2](https://github.com/gjtorikian/html-proofer/tree/v3.0.2) (2016-03-05)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.0.1...v3.0.2)

**Merged pull requests:**

- Swap external URL paths [\#312](https://github.com/gjtorikian/html-proofer/pull/312) ([gjtorikian](https://github.com/gjtorikian))

## [v3.0.1](https://github.com/gjtorikian/html-proofer/tree/v3.0.1) (2016-03-05)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v3.0.0...v3.0.1)

**Breaking changes:**

- Rename to `html-proofer` [\#278](https://github.com/gjtorikian/html-proofer/issues/278)
- Rename `htmlproof` to `htmlproofer` [\#246](https://github.com/gjtorikian/html-proofer/issues/246)
- Drop `verbose` in a future release [\#240](https://github.com/gjtorikian/html-proofer/issues/240)
- Drop `href_ignore` in a future release [\#214](https://github.com/gjtorikian/html-proofer/issues/214)

**Closed issues:**

- HTML-Proofer ignores 'data-proofer-ignore' [\#306](https://github.com/gjtorikian/html-proofer/issues/306)
- Recent Travis failures [\#299](https://github.com/gjtorikian/html-proofer/issues/299)
- Tag picture invalid [\#298](https://github.com/gjtorikian/html-proofer/issues/298)
- Truly disable caching [\#294](https://github.com/gjtorikian/html-proofer/issues/294)
- Errors using `verbosity` option [\#284](https://github.com/gjtorikian/html-proofer/issues/284)
- Reexamine usage of attr\_accessor [\#257](https://github.com/gjtorikian/html-proofer/issues/257)
- Clean up logger [\#256](https://github.com/gjtorikian/html-proofer/issues/256)
- External Links: Adding the option to customize which 4xx fail would be great [\#223](https://github.com/gjtorikian/html-proofer/issues/223)
- Introduce url\_swap as companion for url\_ignore [\#219](https://github.com/gjtorikian/html-proofer/issues/219)
- Include a separate directory to search for the "Links" check? [\#139](https://github.com/gjtorikian/html-proofer/issues/139)

## [v3.0.0](https://github.com/gjtorikian/html-proofer/tree/v3.0.0) (2016-03-05)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.6.4...v3.0.0)

**Closed issues:**

- HTML pretty links & extensions [\#309](https://github.com/gjtorikian/html-proofer/issues/309)
- HGroup listed as Invalid Tag [\#308](https://github.com/gjtorikian/html-proofer/issues/308)
- HTML5 allows omitting anchor href, html-proofer does not. [\#254](https://github.com/gjtorikian/html-proofer/issues/254)

**Merged pull requests:**

- Allow extensionless URLs [\#311](https://github.com/gjtorikian/html-proofer/pull/311) ([Floppy](https://github.com/Floppy))
- Ignore namespaces in tags [\#307](https://github.com/gjtorikian/html-proofer/pull/307) ([gjtorikian](https://github.com/gjtorikian))
- Cache improvements [\#305](https://github.com/gjtorikian/html-proofer/pull/305) ([gjtorikian](https://github.com/gjtorikian))
- HTML-Proofer 3.0 [\#303](https://github.com/gjtorikian/html-proofer/pull/303) ([gjtorikian](https://github.com/gjtorikian))
- Disable caching directory creation [\#302](https://github.com/gjtorikian/html-proofer/pull/302) ([gjtorikian](https://github.com/gjtorikian))
- Fix verbosity issues [\#301](https://github.com/gjtorikian/html-proofer/pull/301) ([gjtorikian](https://github.com/gjtorikian))
- Change HTML validations to opt-in [\#300](https://github.com/gjtorikian/html-proofer/pull/300) ([gjtorikian](https://github.com/gjtorikian))
- Better tests for URL swap [\#297](https://github.com/gjtorikian/html-proofer/pull/297) ([gjtorikian](https://github.com/gjtorikian))
- Modularize the gem [\#296](https://github.com/gjtorikian/html-proofer/pull/296) ([gjtorikian](https://github.com/gjtorikian))
- Clean up attr\_accessor and handling of checks [\#292](https://github.com/gjtorikian/html-proofer/pull/292) ([gjtorikian](https://github.com/gjtorikian))
- Restructure classes and binary program [\#291](https://github.com/gjtorikian/html-proofer/pull/291) ([gjtorikian](https://github.com/gjtorikian))
- Drop href ignore/swap in favor of url ignore/swap [\#288](https://github.com/gjtorikian/html-proofer/pull/288) ([gjtorikian](https://github.com/gjtorikian))
- Allow HTML5 anchors to not need `href` [\#276](https://github.com/gjtorikian/html-proofer/pull/276) ([gjtorikian](https://github.com/gjtorikian))

## [v2.6.4](https://github.com/gjtorikian/html-proofer/tree/v2.6.4) (2016-01-26)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.6.3...v2.6.4)

## [v2.6.3](https://github.com/gjtorikian/html-proofer/tree/v2.6.3) (2016-01-26)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.6.2...v2.6.3)

## [v2.6.2](https://github.com/gjtorikian/html-proofer/tree/v2.6.2) (2016-01-26)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.6.1...v2.6.2)

**Closed issues:**

- Make sure `%20` encoded external URLs work [\#295](https://github.com/gjtorikian/html-proofer/issues/295)
- Fails with `Parallel::DeadWorker: Parallel::DeadWorker` on Travis [\#289](https://github.com/gjtorikian/html-proofer/issues/289)
- Links to github issues failing with 400 [\#283](https://github.com/gjtorikian/html-proofer/issues/283)
- Invalid element name: code [\#280](https://github.com/gjtorikian/html-proofer/issues/280)
- Using htmlproof with Jekyll's baseurl [\#266](https://github.com/gjtorikian/html-proofer/issues/266)
- Internal link not recognized when expressed in different encoding [\#190](https://github.com/gjtorikian/html-proofer/issues/190)

**Merged pull requests:**

- Search for decoded internal IDs, too [\#285](https://github.com/gjtorikian/html-proofer/pull/285) ([gjtorikian](https://github.com/gjtorikian))

## [v2.6.1](https://github.com/gjtorikian/html-proofer/tree/v2.6.1) (2015-12-09)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.6.0...v2.6.1)

**Merged pull requests:**

- Fix attempts at cleaning content [\#281](https://github.com/gjtorikian/html-proofer/pull/281) ([gjtorikian](https://github.com/gjtorikian))

## [v2.6.0](https://github.com/gjtorikian/html-proofer/tree/v2.6.0) (2015-12-05)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.5.2...v2.6.0)

**Closed issues:**

- Does it test orphan pages? [\#275](https://github.com/gjtorikian/html-proofer/issues/275)
- 302/301's fail with relative location [\#272](https://github.com/gjtorikian/html-proofer/issues/272)
- Is there an argument in order to ignore empty mailto? [\#271](https://github.com/gjtorikian/html-proofer/issues/271)
- --allow-hash-href option invalid in 2.5.2 [\#270](https://github.com/gjtorikian/html-proofer/issues/270)
- htmlParseEntityRef throws error for valid iframe src URLs [\#267](https://github.com/gjtorikian/html-proofer/issues/267)
- Empty hash in URL [\#255](https://github.com/gjtorikian/html-proofer/issues/255)
- Spurious "Couldn't resolve host name" errors [\#253](https://github.com/gjtorikian/html-proofer/issues/253)
- Tests take long when checking external links [\#237](https://github.com/gjtorikian/html-proofer/issues/237)

**Merged pull requests:**

- Unify configuration between README and executable [\#279](https://github.com/gjtorikian/html-proofer/pull/279) ([gjtorikian](https://github.com/gjtorikian))
- Add option to \*just\* check for external issues [\#277](https://github.com/gjtorikian/html-proofer/pull/277) ([gjtorikian](https://github.com/gjtorikian))
- Just a single regex will do [\#274](https://github.com/gjtorikian/html-proofer/pull/274) ([gjtorikian](https://github.com/gjtorikian))
- Clean content before parsing with Nokogiri [\#273](https://github.com/gjtorikian/html-proofer/pull/273) ([gjtorikian](https://github.com/gjtorikian))
- Regex example for clarity [\#269](https://github.com/gjtorikian/html-proofer/pull/269) ([plaindocs](https://github.com/plaindocs))
- Set `max_concurrency` to `50` [\#268](https://github.com/gjtorikian/html-proofer/pull/268) ([gjtorikian](https://github.com/gjtorikian))
- Added --allow-hash-href option [\#264](https://github.com/gjtorikian/html-proofer/pull/264) ([johnzeringue](https://github.com/johnzeringue))
- Cache external URL results [\#249](https://github.com/gjtorikian/html-proofer/pull/249) ([gjtorikian](https://github.com/gjtorikian))

## [v2.5.2](https://github.com/gjtorikian/html-proofer/tree/v2.5.2) (2015-11-06)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.5.1...v2.5.2)

**Closed issues:**

- CI --ignore-script-embeds not working for me [\#261](https://github.com/gjtorikian/html-proofer/issues/261)
- Add "directory-index" setting [\#259](https://github.com/gjtorikian/html-proofer/issues/259)
- git error [\#258](https://github.com/gjtorikian/html-proofer/issues/258)
- Warnings for non-https anchors [\#252](https://github.com/gjtorikian/html-proofer/issues/252)
- html-proofer should eat Typhoeus exceptions [\#248](https://github.com/gjtorikian/html-proofer/issues/248)
- Incremental output [\#247](https://github.com/gjtorikian/html-proofer/issues/247)
- Error:  `@shot.' is not allowed as an instance variable name [\#245](https://github.com/gjtorikian/html-proofer/issues/245)
- Don't count `?` forms with different parameters as different [\#236](https://github.com/gjtorikian/html-proofer/issues/236)

**Merged pull requests:**

- Pass along `ignore_script_embeds` in bin [\#263](https://github.com/gjtorikian/html-proofer/pull/263) ([gjtorikian](https://github.com/gjtorikian))
- Don't bundle everything up in the gem [\#262](https://github.com/gjtorikian/html-proofer/pull/262) ([gjtorikian](https://github.com/gjtorikian))
- Add support for enforcing HTTPS links [\#260](https://github.com/gjtorikian/html-proofer/pull/260) ([gjtorikian](https://github.com/gjtorikian))
- Fixed --ignore\_script\_embeds argument when passed through CLI [\#251](https://github.com/gjtorikian/html-proofer/pull/251) ([kidk](https://github.com/kidk))
- Do not explode on error [\#250](https://github.com/gjtorikian/html-proofer/pull/250) ([gjtorikian](https://github.com/gjtorikian))

## [v2.5.1](https://github.com/gjtorikian/html-proofer/tree/v2.5.1) (2015-09-08)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.5.0...v2.5.1)

**Merged pull requests:**

- Move query string check inline into UrlValidator [\#244](https://github.com/gjtorikian/html-proofer/pull/244) ([gjtorikian](https://github.com/gjtorikian))

## [v2.5.0](https://github.com/gjtorikian/html-proofer/tree/v2.5.0) (2015-09-08)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.4.2...v2.5.0)

**Closed issues:**

- --empty-alt-ignore option not followed [\#241](https://github.com/gjtorikian/html-proofer/issues/241)
- Space in URL gives "failed: 404 No error" [\#176](https://github.com/gjtorikian/html-proofer/issues/176)

**Merged pull requests:**

- Loosen up query check [\#243](https://github.com/gjtorikian/html-proofer/pull/243) ([gjtorikian](https://github.com/gjtorikian))
- Refactor a bit [\#242](https://github.com/gjtorikian/html-proofer/pull/242) ([gjtorikian](https://github.com/gjtorikian))

## [v2.4.2](https://github.com/gjtorikian/html-proofer/tree/v2.4.2) (2015-09-01)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.4.1...v2.4.2)

**Merged pull requests:**

- correct ignore script option [\#239](https://github.com/gjtorikian/html-proofer/pull/239) ([geobrando](https://github.com/geobrando))

## [v2.4.1](https://github.com/gjtorikian/html-proofer/tree/v2.4.1) (2015-09-01)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.4.0...v2.4.1)

**Merged pull requests:**

- Ignore cases when checking internal IDs [\#238](https://github.com/gjtorikian/html-proofer/pull/238) ([gjtorikian](https://github.com/gjtorikian))

## [v2.4.0](https://github.com/gjtorikian/html-proofer/tree/v2.4.0) (2015-09-01)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.3.0...v2.4.0)

**Closed issues:**

- Ignore script templates [\#233](https://github.com/gjtorikian/html-proofer/issues/233)
- htmlParseEntityRef has no line number [\#232](https://github.com/gjtorikian/html-proofer/issues/232)
- External Link Checking - Timeouts [\#231](https://github.com/gjtorikian/html-proofer/issues/231)
- url\_ignore not available through the CLI [\#229](https://github.com/gjtorikian/html-proofer/issues/229)
- Empty alt tag [\#228](https://github.com/gjtorikian/html-proofer/issues/228)
- Wrong error shown [\#226](https://github.com/gjtorikian/html-proofer/issues/226)

**Merged pull requests:**

- Add line numbers to failing HTML checks [\#235](https://github.com/gjtorikian/html-proofer/pull/235) ([gjtorikian](https://github.com/gjtorikian))
- Ignore embedded scripts when asked [\#234](https://github.com/gjtorikian/html-proofer/pull/234) ([gjtorikian](https://github.com/gjtorikian))
- Add the url\_ignore option to the binary [\#230](https://github.com/gjtorikian/html-proofer/pull/230) ([doktorbro](https://github.com/doktorbro))
- Use VCR to record and replay HTTP interactions [\#227](https://github.com/gjtorikian/html-proofer/pull/227) ([gjtorikian](https://github.com/gjtorikian))

## [v2.3.0](https://github.com/gjtorikian/html-proofer/tree/v2.3.0) (2015-07-01)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.2.0...v2.3.0)

**Closed issues:**

- Include sitemap.xml in validation [\#218](https://github.com/gjtorikian/html-proofer/issues/218)
- README code correction [\#216](https://github.com/gjtorikian/html-proofer/issues/216)
- 999 No error from Linkedin urls [\#215](https://github.com/gjtorikian/html-proofer/issues/215)
- Ignore attributes other than href [\#213](https://github.com/gjtorikian/html-proofer/issues/213)
- Exclude references via RegEx? [\#211](https://github.com/gjtorikian/html-proofer/issues/211)
- Empty `alt` tags should also be ignored [\#203](https://github.com/gjtorikian/html-proofer/issues/203)

**Merged pull requests:**

- Wikipedia sends 301 now [\#224](https://github.com/gjtorikian/html-proofer/pull/224) ([doktorbro](https://github.com/doktorbro))
- Removed Codeclimate [\#222](https://github.com/gjtorikian/html-proofer/pull/222) ([doktorbro](https://github.com/doktorbro))
- Accept the content attribute [\#220](https://github.com/gjtorikian/html-proofer/pull/220) ([doktorbro](https://github.com/doktorbro))
- corrected code snippet missing curly bracket [\#217](https://github.com/gjtorikian/html-proofer/pull/217) ([jonbartlett](https://github.com/jonbartlett))
- Make href\_ignore work on all elements [\#212](https://github.com/gjtorikian/html-proofer/pull/212) ([doktorbro](https://github.com/doktorbro))
- Fix the insecure example [\#210](https://github.com/gjtorikian/html-proofer/pull/210) ([doktorbro](https://github.com/doktorbro))
- Explain how to ignore certificates [\#209](https://github.com/gjtorikian/html-proofer/pull/209) ([doktorbro](https://github.com/doktorbro))

## [v2.2.0](https://github.com/gjtorikian/html-proofer/tree/v2.2.0) (2015-04-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.1.0...v2.2.0)

**Closed issues:**

- failed: 0 Server returned nothing \(no headers, no data\) [\#200](https://github.com/gjtorikian/html-proofer/issues/200)
- How to use regex in --href-ignore argument [\#199](https://github.com/gjtorikian/html-proofer/issues/199)
- 403 error for drupal.org domain [\#197](https://github.com/gjtorikian/html-proofer/issues/197)
- Problems with --href-swap  [\#192](https://github.com/gjtorikian/html-proofer/issues/192)
- Do not check for favicon link on Redirect pages [\#191](https://github.com/gjtorikian/html-proofer/issues/191)
- invalid option: --ignore [\#186](https://github.com/gjtorikian/html-proofer/issues/186)
- invalid option: --ignore [\#185](https://github.com/gjtorikian/html-proofer/issues/185)
- Check for images on a CDN [\#184](https://github.com/gjtorikian/html-proofer/issues/184)
- Warn about size of a downloaded page? [\#183](https://github.com/gjtorikian/html-proofer/issues/183)
- Using --file-ignore from command line [\#177](https://github.com/gjtorikian/html-proofer/issues/177)
- Crash with "`@:' is not allowed as an instance variable name" [\#173](https://github.com/gjtorikian/html-proofer/issues/173)
- fix support of urls in link rel="canonical" [\#170](https://github.com/gjtorikian/html-proofer/issues/170)
- Problems with 301s and hash tag refs [\#126](https://github.com/gjtorikian/html-proofer/issues/126)

**Merged pull requests:**

- Add --ignore-empty-alt [\#207](https://github.com/gjtorikian/html-proofer/pull/207) ([gjtorikian](https://github.com/gjtorikian))
- Force remove some badly decomposed UTF8 files [\#206](https://github.com/gjtorikian/html-proofer/pull/206) ([gjtorikian](https://github.com/gjtorikian))
- Strip whitespace from empty `alt` tags [\#205](https://github.com/gjtorikian/html-proofer/pull/205) ([gjtorikian](https://github.com/gjtorikian))
- Better Typhoeus option handling [\#204](https://github.com/gjtorikian/html-proofer/pull/204) ([gjtorikian](https://github.com/gjtorikian))
- Faster Travis builds [\#202](https://github.com/gjtorikian/html-proofer/pull/202) ([benbalter](https://github.com/benbalter))
- Set default user agent [\#201](https://github.com/gjtorikian/html-proofer/pull/201) ([benbalter](https://github.com/benbalter))
- only split into two [\#193](https://github.com/gjtorikian/html-proofer/pull/193) ([eksperimental](https://github.com/eksperimental))
- correct --swap [\#188](https://github.com/gjtorikian/html-proofer/pull/188) ([eksperimental](https://github.com/eksperimental))
- correct --ignore option [\#187](https://github.com/gjtorikian/html-proofer/pull/187) ([eksperimental](https://github.com/eksperimental))
- Accept namespace attributes [\#181](https://github.com/gjtorikian/html-proofer/pull/181) ([doktorbro](https://github.com/doktorbro))
- Add support for validation of all svg elements. [\#180](https://github.com/gjtorikian/html-proofer/pull/180) ([mareksuscak](https://github.com/mareksuscak))
- Speed up the mailto check [\#174](https://github.com/gjtorikian/html-proofer/pull/174) ([doktorbro](https://github.com/doktorbro))
- Add Code Climate [\#169](https://github.com/gjtorikian/html-proofer/pull/169) ([doktorbro](https://github.com/doktorbro))

## [v2.1.0](https://github.com/gjtorikian/html-proofer/tree/v2.1.0) (2015-02-10)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.0.6...v2.1.0)

**Merged pull requests:**

- Upgrade Typhoeus to 0.7 [\#172](https://github.com/gjtorikian/html-proofer/pull/172) ([doktorbro](https://github.com/doktorbro))
- Test Ruby 2.2 too [\#171](https://github.com/gjtorikian/html-proofer/pull/171) ([doktorbro](https://github.com/doktorbro))

## [v2.0.6](https://github.com/gjtorikian/html-proofer/tree/v2.0.6) (2015-02-10)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.0.5...v2.0.6)

**Fixed bugs:**

- SSL connect error [\#141](https://github.com/gjtorikian/html-proofer/issues/141)

**Closed issues:**

- Why stop updating broken links? [\#75](https://github.com/gjtorikian/html-proofer/issues/75)

**Merged pull requests:**

- Unencode URLs with Addressable [\#168](https://github.com/gjtorikian/html-proofer/pull/168) ([doktorbro](https://github.com/doktorbro))

## [v2.0.5](https://github.com/gjtorikian/html-proofer/tree/v2.0.5) (2015-02-03)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.0.4...v2.0.5)

**Merged pull requests:**

- Add missing cgi dependency [\#167](https://github.com/gjtorikian/html-proofer/pull/167) ([johnelse](https://github.com/johnelse))

## [v2.0.4](https://github.com/gjtorikian/html-proofer/tree/v2.0.4) (2015-02-01)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.0.3...v2.0.4)

**Closed issues:**

- Distinguish between missing and empty attributes [\#160](https://github.com/gjtorikian/html-proofer/issues/160)

**Merged pull requests:**

- Add missing argument [\#165](https://github.com/gjtorikian/html-proofer/pull/165) ([gjtorikian](https://github.com/gjtorikian))

## [v2.0.3](https://github.com/gjtorikian/html-proofer/tree/v2.0.3) (2015-01-31)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.0.2...v2.0.3)

**Closed issues:**

- ArgumentError: wrong number of arguments  [\#162](https://github.com/gjtorikian/html-proofer/issues/162)
- Error executing htmlproof [\#161](https://github.com/gjtorikian/html-proofer/issues/161)

**Merged pull requests:**

- Add params to UrlValidator\#handle\_timeout per its usage [\#163](https://github.com/gjtorikian/html-proofer/pull/163) ([parkr](https://github.com/parkr))

## [v2.0.2](https://github.com/gjtorikian/html-proofer/tree/v2.0.2) (2015-01-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.0.1...v2.0.2)

**Closed issues:**

- Support HTML5 data attributes [\#158](https://github.com/gjtorikian/html-proofer/issues/158)

**Merged pull requests:**

- Translate attributes with dashes into underscores [\#159](https://github.com/gjtorikian/html-proofer/pull/159) ([gjtorikian](https://github.com/gjtorikian))

## [v2.0.1](https://github.com/gjtorikian/html-proofer/tree/v2.0.1) (2015-01-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v2.0.0...v2.0.1)

**Closed issues:**

- Uninitialized constant HTML [\#157](https://github.com/gjtorikian/html-proofer/issues/157)

## [v2.0.0](https://github.com/gjtorikian/html-proofer/tree/v2.0.0) (2015-01-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.6.0...v2.0.0)

**Closed issues:**

- Problem building gem from source [\#156](https://github.com/gjtorikian/html-proofer/issues/156)
- srcset raising error [\#149](https://github.com/gjtorikian/html-proofer/issues/149)
- No line numbers in error output [\#146](https://github.com/gjtorikian/html-proofer/issues/146)
- file\_ignore list only looks at first argument ? [\#145](https://github.com/gjtorikian/html-proofer/issues/145)
- Failures on urlencoded hrefs [\#143](https://github.com/gjtorikian/html-proofer/issues/143)
- Cannot test HTTPS URLs on travis [\#140](https://github.com/gjtorikian/html-proofer/issues/140)
- Is there a way to only perform the "Links" and "Scripts" checks and not the "Images" check? [\#138](https://github.com/gjtorikian/html-proofer/issues/138)
- Add throttle options [\#131](https://github.com/gjtorikian/html-proofer/issues/131)
- Refactor `run` method [\#129](https://github.com/gjtorikian/html-proofer/issues/129)
- Namespace Typhoeus options [\#114](https://github.com/gjtorikian/html-proofer/issues/114)
- Redirected links don't report original href in log [\#77](https://github.com/gjtorikian/html-proofer/issues/77)
- Checking the srcset attribute [\#70](https://github.com/gjtorikian/html-proofer/issues/70)

**Merged pull requests:**

- Report errors on original href, maybe [\#155](https://github.com/gjtorikian/html-proofer/pull/155) ([gjtorikian](https://github.com/gjtorikian))
- Add basic line number support [\#154](https://github.com/gjtorikian/html-proofer/pull/154) ([gjtorikian](https://github.com/gjtorikian))
- Proper iteration over multiple file ignores [\#153](https://github.com/gjtorikian/html-proofer/pull/153) ([gjtorikian](https://github.com/gjtorikian))
- Improve support for the href\_swap feature [\#152](https://github.com/gjtorikian/html-proofer/pull/152) ([gjtorikian](https://github.com/gjtorikian))
- Add support for `checks_to_ignore` [\#151](https://github.com/gjtorikian/html-proofer/pull/151) ([gjtorikian](https://github.com/gjtorikian))
- Add support for srcset [\#150](https://github.com/gjtorikian/html-proofer/pull/150) ([gjtorikian](https://github.com/gjtorikian))
- Refactor html-proofer [\#147](https://github.com/gjtorikian/html-proofer/pull/147) ([gjtorikian](https://github.com/gjtorikian))
- Create a test for urlencoded file name [\#144](https://github.com/gjtorikian/html-proofer/pull/144) ([doktorbro](https://github.com/doktorbro))
- Don't use deprecated method [\#142](https://github.com/gjtorikian/html-proofer/pull/142) ([myokoym](https://github.com/myokoym))
- Support for non-UTF-8 encoded URLs [\#137](https://github.com/gjtorikian/html-proofer/pull/137) ([benbalter](https://github.com/benbalter))

## [v1.6.0](https://github.com/gjtorikian/html-proofer/tree/v1.6.0) (2014-12-11)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.5.4...v1.6.0)

**Closed issues:**

- Error: Could not load 'libcurl' [\#135](https://github.com/gjtorikian/html-proofer/issues/135)

**Merged pull requests:**

- Add support for ignoring files [\#136](https://github.com/gjtorikian/html-proofer/pull/136) ([gjtorikian](https://github.com/gjtorikian))

## [v1.5.4](https://github.com/gjtorikian/html-proofer/tree/v1.5.4) (2014-11-14)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.5.3...v1.5.4)

**Merged pull requests:**

- Adjustments for re-queuing URLs [\#134](https://github.com/gjtorikian/html-proofer/pull/134) ([gjtorikian](https://github.com/gjtorikian))

## [v1.5.3](https://github.com/gjtorikian/html-proofer/tree/v1.5.3) (2014-11-14)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.5.2...v1.5.3)

**Merged pull requests:**

- Make external hash checker an option [\#133](https://github.com/gjtorikian/html-proofer/pull/133) ([gjtorikian](https://github.com/gjtorikian))

## [v1.5.2](https://github.com/gjtorikian/html-proofer/tree/v1.5.2) (2014-11-12)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.5.1...v1.5.2)

**Merged pull requests:**

- Only add external links once [\#132](https://github.com/gjtorikian/html-proofer/pull/132) ([gjtorikian](https://github.com/gjtorikian))

## [v1.5.1](https://github.com/gjtorikian/html-proofer/tree/v1.5.1) (2014-11-11)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.5.0...v1.5.1)

## [v1.5.0](https://github.com/gjtorikian/html-proofer/tree/v1.5.0) (2014-11-11)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.4.0...v1.5.0)

**Fixed bugs:**

- Proofer raises false positive on RSS feeds [\#121](https://github.com/gjtorikian/html-proofer/issues/121)
- URLs with parameters deemed invalid [\#117](https://github.com/gjtorikian/html-proofer/issues/117)

**Closed issues:**

- irc:// = error [\#130](https://github.com/gjtorikian/html-proofer/issues/130)
- Failing test: "Links test: fails on redirects if not following" [\#124](https://github.com/gjtorikian/html-proofer/issues/124)
- Error when linking to git://, ftp:// etc. URIs [\#119](https://github.com/gjtorikian/html-proofer/issues/119)
- False positive on link with url encoded character [\#110](https://github.com/gjtorikian/html-proofer/issues/110)
- Make the output more readable [\#72](https://github.com/gjtorikian/html-proofer/issues/72)

**Merged pull requests:**

- Remove unused code path [\#128](https://github.com/gjtorikian/html-proofer/pull/128) ([gjtorikian](https://github.com/gjtorikian))
- Simplify "no redirects" test [\#127](https://github.com/gjtorikian/html-proofer/pull/127) ([gjtorikian](https://github.com/gjtorikian))
- Added an html validation check by looking at Nokogiri errors [\#125](https://github.com/gjtorikian/html-proofer/pull/125) ([akoeplinger](https://github.com/akoeplinger))
- Add a version file [\#123](https://github.com/gjtorikian/html-proofer/pull/123) ([parkr](https://github.com/parkr))
- Better URL parsing through science [\#122](https://github.com/gjtorikian/html-proofer/pull/122) ([benbalter](https://github.com/benbalter))
- Ignore any non-HTTP\(S\) URI [\#120](https://github.com/gjtorikian/html-proofer/pull/120) ([gjtorikian](https://github.com/gjtorikian))
- Provide more organized output and sorting [\#116](https://github.com/gjtorikian/html-proofer/pull/116) ([gjtorikian](https://github.com/gjtorikian))
- Fix head request checks with hashtag [\#100](https://github.com/gjtorikian/html-proofer/pull/100) ([gjtorikian](https://github.com/gjtorikian))

## [v1.4.0](https://github.com/gjtorikian/html-proofer/tree/v1.4.0) (2014-09-13)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.3.3...v1.4.0)

**Closed issues:**

- Hanging on run [\#109](https://github.com/gjtorikian/html-proofer/issues/109)

**Merged pull requests:**

- Accept parallel options [\#115](https://github.com/gjtorikian/html-proofer/pull/115) ([gjtorikian](https://github.com/gjtorikian))
- Process files in parallel to improve performance [\#113](https://github.com/gjtorikian/html-proofer/pull/113) ([akoeplinger](https://github.com/akoeplinger))
- Cache the Uri parser instance in Checkable, results in a 14x performance increase [\#112](https://github.com/gjtorikian/html-proofer/pull/112) ([akoeplinger](https://github.com/akoeplinger))

## [v1.3.3](https://github.com/gjtorikian/html-proofer/tree/v1.3.3) (2014-08-28)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.3.2...v1.3.3)

**Fixed bugs:**

- Error “internally linking to , which does not exist” [\#104](https://github.com/gjtorikian/html-proofer/issues/104)

**Merged pull requests:**

- Ignore placeholders [\#107](https://github.com/gjtorikian/html-proofer/pull/107) ([doktorbro](https://github.com/doktorbro))
- Fix the directory index test [\#105](https://github.com/gjtorikian/html-proofer/pull/105) ([doktorbro](https://github.com/doktorbro))

## [v1.3.2](https://github.com/gjtorikian/html-proofer/tree/v1.3.2) (2014-08-26)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.3.1...v1.3.2)

**Fixed bugs:**

- Crash when folder named \*.html [\#99](https://github.com/gjtorikian/html-proofer/issues/99)

**Closed issues:**

- internal links to element id's are not found [\#102](https://github.com/gjtorikian/html-proofer/issues/102)

**Merged pull requests:**

- Fix hash referring to self [\#103](https://github.com/gjtorikian/html-proofer/pull/103) ([gjtorikian](https://github.com/gjtorikian))
- Make sure \#files contains no directory [\#101](https://github.com/gjtorikian/html-proofer/pull/101) ([doktorbro](https://github.com/doktorbro))

## [v1.3.1](https://github.com/gjtorikian/html-proofer/tree/v1.3.1) (2014-08-24)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.3.0...v1.3.1)

**Closed issues:**

- allow links to sites with self-signed certs? [\#97](https://github.com/gjtorikian/html-proofer/issues/97)

**Merged pull requests:**

- Properly pass Typhoeus options [\#98](https://github.com/gjtorikian/html-proofer/pull/98) ([gjtorikian](https://github.com/gjtorikian))

## [v1.3.0](https://github.com/gjtorikian/html-proofer/tree/v1.3.0) (2014-08-22)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.2.1...v1.3.0)

**Fixed bugs:**

- Crash on broken internal query without index [\#93](https://github.com/gjtorikian/html-proofer/pull/93) ([doktorbro](https://github.com/doktorbro))

**Closed issues:**

- Real life usage examples [\#89](https://github.com/gjtorikian/html-proofer/issues/89)
- No such file or directory @ rb\_sysopen [\#41](https://github.com/gjtorikian/html-proofer/issues/41)
- Issues with SSL checks [\#40](https://github.com/gjtorikian/html-proofer/issues/40)

**Merged pull requests:**

- Add new `only_4xx` key to report just 4xx errors [\#96](https://github.com/gjtorikian/html-proofer/pull/96) ([gjtorikian](https://github.com/gjtorikian))
- Run specs in a random order [\#95](https://github.com/gjtorikian/html-proofer/pull/95) ([doktorbro](https://github.com/doktorbro))
- Remove `escape_utils` dependency [\#94](https://github.com/gjtorikian/html-proofer/pull/94) ([doktorbro](https://github.com/doktorbro))
- Proof the readme [\#92](https://github.com/gjtorikian/html-proofer/pull/92) ([doktorbro](https://github.com/doktorbro))
- Add real-life examples [\#91](https://github.com/gjtorikian/html-proofer/pull/91) ([doktorbro](https://github.com/doktorbro))
- Refactor files function [\#90](https://github.com/gjtorikian/html-proofer/pull/90) ([doktorbro](https://github.com/doktorbro))
- Add test for Google font css [\#88](https://github.com/gjtorikian/html-proofer/pull/88) ([doktorbro](https://github.com/doktorbro))
- Remove space in example config setter [\#87](https://github.com/gjtorikian/html-proofer/pull/87) ([nschonni](https://github.com/nschonni))
- Create Issue class [\#71](https://github.com/gjtorikian/html-proofer/pull/71) ([doktorbro](https://github.com/doktorbro))
- Respect the ignore for favicons [\#69](https://github.com/gjtorikian/html-proofer/pull/69) ([doktorbro](https://github.com/doktorbro))

## [v1.2.1](https://github.com/gjtorikian/html-proofer/tree/v1.2.1) (2014-08-08)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.2.0...v1.2.1)

**Merged pull requests:**

- Don't colorize failed tests unless printing to a TTY [\#85](https://github.com/gjtorikian/html-proofer/pull/85) ([aroben](https://github.com/aroben))

## [v1.2.0](https://github.com/gjtorikian/html-proofer/tree/v1.2.0) (2014-08-08)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.1.6...v1.2.0)

**Closed issues:**

- undefined method `version` error [\#82](https://github.com/gjtorikian/html-proofer/issues/82)

**Merged pull requests:**

- Only colorize strings when printing to a TTY [\#84](https://github.com/gjtorikian/html-proofer/pull/84) ([aroben](https://github.com/aroben))
- Speed up retrying of failed external link checks [\#83](https://github.com/gjtorikian/html-proofer/pull/83) ([aroben](https://github.com/aroben))

## [v1.1.6](https://github.com/gjtorikian/html-proofer/tree/v1.1.6) (2014-08-08)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.1.5...v1.1.6)

## [v1.1.5](https://github.com/gjtorikian/html-proofer/tree/v1.1.5) (2014-08-07)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.1.4...v1.1.5)

**Closed issues:**

- Mysterious "link has no href attribute" error [\#79](https://github.com/gjtorikian/html-proofer/issues/79)
- Prose checking [\#78](https://github.com/gjtorikian/html-proofer/issues/78)

**Merged pull requests:**

- Some more cosemtic changes [\#81](https://github.com/gjtorikian/html-proofer/pull/81) ([gjtorikian](https://github.com/gjtorikian))
- Make it clear this refers to an anchor, not a link [\#80](https://github.com/gjtorikian/html-proofer/pull/80) ([gjtorikian](https://github.com/gjtorikian))

## [v1.1.4](https://github.com/gjtorikian/html-proofer/tree/v1.1.4) (2014-07-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.1.3...v1.1.4)

**Closed issues:**

- Trying to ignore all alt tags ignores all links [\#76](https://github.com/gjtorikian/html-proofer/issues/76)
- in-href JS returns error [\#73](https://github.com/gjtorikian/html-proofer/issues/73)
- Awesome [\#66](https://github.com/gjtorikian/html-proofer/issues/66)
- Redirects don't appear to be handled properly [\#32](https://github.com/gjtorikian/html-proofer/issues/32)

**Merged pull requests:**

- Properly ignore jaavscript in href [\#74](https://github.com/gjtorikian/html-proofer/pull/74) ([gjtorikian](https://github.com/gjtorikian))
- Mention the followlocation option [\#68](https://github.com/gjtorikian/html-proofer/pull/68) ([doktorbro](https://github.com/doktorbro))
- Remove pres and codes from the document [\#67](https://github.com/gjtorikian/html-proofer/pull/67) ([doktorbro](https://github.com/doktorbro))

## [v1.1.3](https://github.com/gjtorikian/html-proofer/tree/v1.1.3) (2014-07-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.1.2...v1.1.3)

## [v1.1.2](https://github.com/gjtorikian/html-proofer/tree/v1.1.2) (2014-07-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.1.1...v1.1.2)

**Merged pull requests:**

- Don't list favicon if not asked for [\#65](https://github.com/gjtorikian/html-proofer/pull/65) ([gjtorikian](https://github.com/gjtorikian))

## [v1.1.1](https://github.com/gjtorikian/html-proofer/tree/v1.1.1) (2014-07-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.1.0...v1.1.1)

**Merged pull requests:**

- Don't check items within pre or code blocks [\#64](https://github.com/gjtorikian/html-proofer/pull/64) ([gjtorikian](https://github.com/gjtorikian))

## [v1.1.0](https://github.com/gjtorikian/html-proofer/tree/v1.1.0) (2014-07-21)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v1.0.0...v1.1.0)

**Merged pull requests:**

- Support passing in an array of links to check [\#63](https://github.com/gjtorikian/html-proofer/pull/63) ([gjtorikian](https://github.com/gjtorikian))

## [v1.0.0](https://github.com/gjtorikian/html-proofer/tree/v1.0.0) (2014-07-20)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.9.0...v1.0.0)

**Closed issues:**

- Need relaxing option for empty alt check [\#39](https://github.com/gjtorikian/html-proofer/issues/39)

**Merged pull requests:**

- Ignore missing alt tags when asked [\#62](https://github.com/gjtorikian/html-proofer/pull/62) ([gjtorikian](https://github.com/gjtorikian))

## [v0.9.0](https://github.com/gjtorikian/html-proofer/tree/v0.9.0) (2014-07-20)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.8.0...v0.9.0)

**Closed issues:**

- Threads/Processes? [\#56](https://github.com/gjtorikian/html-proofer/issues/56)
- Remove double \n in output [\#54](https://github.com/gjtorikian/html-proofer/issues/54)
- Warn on permanent redirects \(301\) [\#48](https://github.com/gjtorikian/html-proofer/issues/48)

**Merged pull requests:**

- Rearrange tests for some organizational sanity [\#61](https://github.com/gjtorikian/html-proofer/pull/61) ([gjtorikian](https://github.com/gjtorikian))
- Always respect the ignore before any rule [\#60](https://github.com/gjtorikian/html-proofer/pull/60) ([gjtorikian](https://github.com/gjtorikian))
- Optional favicon checker [\#59](https://github.com/gjtorikian/html-proofer/pull/59) ([doktorbro](https://github.com/doktorbro))
- Improve the options description [\#58](https://github.com/gjtorikian/html-proofer/pull/58) ([doktorbro](https://github.com/doktorbro))
- Don't concat so much extra space [\#55](https://github.com/gjtorikian/html-proofer/pull/55) ([parkr](https://github.com/parkr))
- Scripts checking [\#53](https://github.com/gjtorikian/html-proofer/pull/53) ([doktorbro](https://github.com/doktorbro))
- Sort issues [\#52](https://github.com/gjtorikian/html-proofer/pull/52) ([doktorbro](https://github.com/doktorbro))
- Specs for permanent redirect warnings [\#49](https://github.com/gjtorikian/html-proofer/pull/49) ([doktorbro](https://github.com/doktorbro))

## [v0.8.0](https://github.com/gjtorikian/html-proofer/tree/v0.8.0) (2014-07-14)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.7.3...v0.8.0)

**Merged pull requests:**

- Check link elements [\#51](https://github.com/gjtorikian/html-proofer/pull/51) ([doktorbro](https://github.com/doktorbro))
- Speed up Nokogiri installation [\#50](https://github.com/gjtorikian/html-proofer/pull/50) ([doktorbro](https://github.com/doktorbro))

## [v0.7.3](https://github.com/gjtorikian/html-proofer/tree/v0.7.3) (2014-07-09)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.7.2...v0.7.3)

## [v0.7.2](https://github.com/gjtorikian/html-proofer/tree/v0.7.2) (2014-06-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.7.1...v0.7.2)

**Closed issues:**

- Getting errors for "//", "mailto:" and "tel:" URLs [\#46](https://github.com/gjtorikian/html-proofer/issues/46)

**Merged pull requests:**

- Investigate broken links [\#47](https://github.com/gjtorikian/html-proofer/pull/47) ([gjtorikian](https://github.com/gjtorikian))

## [v0.7.1](https://github.com/gjtorikian/html-proofer/tree/v0.7.1) (2014-06-13)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.7.0...v0.7.1)

**Merged pull requests:**

- Add note about NOKOGIRI\_USE\_SYSTEM\_LIBRARIES to README [\#45](https://github.com/gjtorikian/html-proofer/pull/45) ([parkr](https://github.com/parkr))

## [v0.7.0](https://github.com/gjtorikian/html-proofer/tree/v0.7.0) (2014-05-27)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.6.8...v0.7.0)

**Merged pull requests:**

- Add HTML::Proofer\#failed\_tests [\#44](https://github.com/gjtorikian/html-proofer/pull/44) ([afeld](https://github.com/afeld))

## [v0.6.8](https://github.com/gjtorikian/html-proofer/tree/v0.6.8) (2014-05-22)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.6.7...v0.6.8)

**Closed issues:**

- Test for valid HTML [\#30](https://github.com/gjtorikian/html-proofer/issues/30)

**Merged pull requests:**

- Add :verbose option to HTML::Proofer to give progress as it goes [\#43](https://github.com/gjtorikian/html-proofer/pull/43) ([parkr](https://github.com/parkr))
- Tell Mercenary to read in --swap and --ignore as arrays [\#42](https://github.com/gjtorikian/html-proofer/pull/42) ([parkr](https://github.com/parkr))
- Update README to show how you can write custom tests [\#38](https://github.com/gjtorikian/html-proofer/pull/38) ([gjtorikian](https://github.com/gjtorikian))

## [v0.6.7](https://github.com/gjtorikian/html-proofer/tree/v0.6.7) (2014-04-07)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.6.6...v0.6.7)

**Closed issues:**

- How to use from command line? [\#33](https://github.com/gjtorikian/html-proofer/issues/33)

## [v0.6.6](https://github.com/gjtorikian/html-proofer/tree/v0.6.6) (2014-04-07)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.6.5...v0.6.6)

## [v0.6.5](https://github.com/gjtorikian/html-proofer/tree/v0.6.5) (2014-04-07)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.6.4...v0.6.5)

**Merged pull requests:**

- Some more improvements to the executable file [\#37](https://github.com/gjtorikian/html-proofer/pull/37) ([gjtorikian](https://github.com/gjtorikian))

## [v0.6.4](https://github.com/gjtorikian/html-proofer/tree/v0.6.4) (2014-03-25)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.6.2...v0.6.4)

## [v0.6.2](https://github.com/gjtorikian/html-proofer/tree/v0.6.2) (2014-03-25)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.6.1...v0.6.2)

## [v0.6.1](https://github.com/gjtorikian/html-proofer/tree/v0.6.1) (2014-03-24)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.6.0...v0.6.1)

**Merged pull requests:**

- Pr/34 [\#35](https://github.com/gjtorikian/html-proofer/pull/35) ([gjtorikian](https://github.com/gjtorikian))
- Replace 'return' with 'next' in block [\#34](https://github.com/gjtorikian/html-proofer/pull/34) ([kansaichris](https://github.com/kansaichris))

## [v0.6.0](https://github.com/gjtorikian/html-proofer/tree/v0.6.0) (2014-02-11)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.5.0...v0.6.0)

**Merged pull requests:**

- Regex the ignore links [\#31](https://github.com/gjtorikian/html-proofer/pull/31) ([gjtorikian](https://github.com/gjtorikian))

## [v0.5.0](https://github.com/gjtorikian/html-proofer/tree/v0.5.0) (2014-01-08)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.4.1...v0.5.0)

**Closed issues:**

- data uris in img tags fails to validate [\#26](https://github.com/gjtorikian/html-proofer/issues/26)

**Merged pull requests:**

- In the event of an error, just try a GET one more time [\#29](https://github.com/gjtorikian/html-proofer/pull/29) ([gjtorikian](https://github.com/gjtorikian))
- Check against SSL links [\#28](https://github.com/gjtorikian/html-proofer/pull/28) ([gjtorikian](https://github.com/gjtorikian))
- Ignore images that are data URI'ed for now [\#27](https://github.com/gjtorikian/html-proofer/pull/27) ([gjtorikian](https://github.com/gjtorikian))

## [v0.4.1](https://github.com/gjtorikian/html-proofer/tree/v0.4.1) (2013-12-31)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.4.0...v0.4.1)

## [v0.4.0](https://github.com/gjtorikian/html-proofer/tree/v0.4.0) (2013-12-31)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.3.0...v0.4.0)

**Closed issues:**

- "Too many open files" error [\#22](https://github.com/gjtorikian/html-proofer/issues/22)
- Nokogiri dependency brings CI builds to a crawl [\#21](https://github.com/gjtorikian/html-proofer/issues/21)
- Integrate Hwacha for Parallelized Checks? [\#20](https://github.com/gjtorikian/html-proofer/issues/20)
- Expose line number in errors [\#3](https://github.com/gjtorikian/html-proofer/issues/3)

**Merged pull requests:**

- Speedup, Redux [\#24](https://github.com/gjtorikian/html-proofer/pull/24) ([gjtorikian](https://github.com/gjtorikian))
- Relative images matter [\#23](https://github.com/gjtorikian/html-proofer/pull/23) ([gjtorikian](https://github.com/gjtorikian))

## [v0.3.0](https://github.com/gjtorikian/html-proofer/tree/v0.3.0) (2013-12-05)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.2.3...v0.3.0)

**Closed issues:**

- Internally cache status of known URLs [\#17](https://github.com/gjtorikian/html-proofer/issues/17)
- Use Commander? [\#10](https://github.com/gjtorikian/html-proofer/issues/10)

**Merged pull requests:**

- Commandline ify [\#19](https://github.com/gjtorikian/html-proofer/pull/19) ([gjtorikian](https://github.com/gjtorikian))
- Cache successful paths internally [\#18](https://github.com/gjtorikian/html-proofer/pull/18) ([gjtorikian](https://github.com/gjtorikian))

## [v0.2.3](https://github.com/gjtorikian/html-proofer/tree/v0.2.3) (2013-10-24)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.2.2...v0.2.3)

## [v0.2.2](https://github.com/gjtorikian/html-proofer/tree/v0.2.2) (2013-10-24)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.2.1...v0.2.2)

## [v0.2.1](https://github.com/gjtorikian/html-proofer/tree/v0.2.1) (2013-10-24)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.2.0...v0.2.1)

**Closed issues:**

- Handle 503s better [\#11](https://github.com/gjtorikian/html-proofer/issues/11)

**Merged pull requests:**

- Retry on 420 and 503 [\#13](https://github.com/gjtorikian/html-proofer/pull/13) ([gjtorikian](https://github.com/gjtorikian))

## [v0.2.0](https://github.com/gjtorikian/html-proofer/tree/v0.2.0) (2013-10-23)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.1.1...v0.2.0)

**Closed issues:**

- Allow URLs to be ignored by attribute [\#7](https://github.com/gjtorikian/html-proofer/issues/7)

**Merged pull requests:**

- Add attribute to ignore links/images [\#12](https://github.com/gjtorikian/html-proofer/pull/12) ([gjtorikian](https://github.com/gjtorikian))

## [v0.1.1](https://github.com/gjtorikian/html-proofer/tree/v0.1.1) (2013-10-15)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.1.0...v0.1.1)

**Merged pull requests:**

- Fix options bug [\#9](https://github.com/gjtorikian/html-proofer/pull/9) ([gjtorikian](https://github.com/gjtorikian))
- Readme tweaks [\#8](https://github.com/gjtorikian/html-proofer/pull/8) ([benbalter](https://github.com/benbalter))

## [v0.1.0](https://github.com/gjtorikian/html-proofer/tree/v0.1.0) (2013-10-14)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.16...v0.1.0)

**Merged pull requests:**

- Refactor [\#6](https://github.com/gjtorikian/html-proofer/pull/6) ([benbalter](https://github.com/benbalter))
- Proper relative URL support [\#5](https://github.com/gjtorikian/html-proofer/pull/5) ([benbalter](https://github.com/benbalter))

## [v0.0.16](https://github.com/gjtorikian/html-proofer/tree/v0.0.16) (2013-10-09)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.15...v0.0.16)

**Merged pull requests:**

- Set to v0.0.16 [\#4](https://github.com/gjtorikian/html-proofer/pull/4) ([gjtorikian](https://github.com/gjtorikian))

## [v0.0.15](https://github.com/gjtorikian/html-proofer/tree/v0.0.15) (2013-10-09)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.14...v0.0.15)

**Merged pull requests:**

- Better Jekyll compatability [\#2](https://github.com/gjtorikian/html-proofer/pull/2) ([benbalter](https://github.com/benbalter))

## [v0.0.14](https://github.com/gjtorikian/html-proofer/tree/v0.0.14) (2013-06-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.13...v0.0.14)

## [v0.0.13](https://github.com/gjtorikian/html-proofer/tree/v0.0.13) (2013-06-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.12...v0.0.13)

## [v0.0.12](https://github.com/gjtorikian/html-proofer/tree/v0.0.12) (2013-06-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.11...v0.0.12)

## [v0.0.11](https://github.com/gjtorikian/html-proofer/tree/v0.0.11) (2013-06-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.10...v0.0.11)

## [v0.0.10](https://github.com/gjtorikian/html-proofer/tree/v0.0.10) (2013-06-29)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.9...v0.0.10)

**Merged pull requests:**

- Parallelize external calls [\#1](https://github.com/gjtorikian/html-proofer/pull/1) ([gjtorikian](https://github.com/gjtorikian))

## [v0.0.9](https://github.com/gjtorikian/html-proofer/tree/v0.0.9) (2013-05-02)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.8...v0.0.9)

## [v0.0.8](https://github.com/gjtorikian/html-proofer/tree/v0.0.8) (2013-04-27)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.7...v0.0.8)

## [v0.0.7](https://github.com/gjtorikian/html-proofer/tree/v0.0.7) (2013-04-17)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.6...v0.0.7)

## [v0.0.6](https://github.com/gjtorikian/html-proofer/tree/v0.0.6) (2013-04-17)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.5...v0.0.6)

## [v0.0.5](https://github.com/gjtorikian/html-proofer/tree/v0.0.5) (2013-04-17)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.4...v0.0.5)

## [v0.0.4](https://github.com/gjtorikian/html-proofer/tree/v0.0.4) (2013-04-17)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.3...v0.0.4)

## [v0.0.3](https://github.com/gjtorikian/html-proofer/tree/v0.0.3) (2013-03-25)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/v0.0.2...v0.0.3)

## [v0.0.2](https://github.com/gjtorikian/html-proofer/tree/v0.0.2) (2013-03-25)

[Full Changelog](https://github.com/gjtorikian/html-proofer/compare/ed79d0948178f9aaf864ab00775098d4aaa21c7d...v0.0.2)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
