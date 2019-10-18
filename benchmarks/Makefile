.PHONY: all 

all: 
	@if [ -d "build" ]; then rm -rf build; fi
	@mkdir build 
	@if [ -e "result" ]; then rm result; fi 
	@touch result 
	@for D in *; do \
	    if [ -d "$${D}" -a $${D} != "build" ]; then \
	    	echo "compiling files in $${D} ....."; \
	    	if [ -d "build/$${D}" ]; then rm -rf build/$${D}; fi; \
	    	mkdir build/$${D}; \
	    	cp -r $${D}/* build/$${D}/; \
			cp $${D}/$${D}.ml build/$${D}/$${D}_inc.ml; \
			sed -i "" "1s/.*/open Tsd_inc/" build/$${D}/$${D}_inc.ml; \
			ocamlfind ocamlopt -w -1..66 -package tsd,tsd.ppx -o build/$${D}/$${D} -linkpkg build/$${D}/$${D}.ml; \
			ocamlfind ocamlopt -w -1..66 -package tsd,tsd.ppx -o build/$${D}/$${D}_inc -linkpkg build/$${D}/$${D}_inc.ml; \
			if [ -d "build/$${D}/rml" ]; then \
				rmlc build/$${D}/rml/*.rml -d build/$${D}/rml/; \
				ocamlfind ocamlopt -w -1..66 -o build/$${D}/rml/$${D} -I `rmlc -where` unix.cmxa rmllib.cmxa build/$${D}/rml/$${D}.ml; \
			fi; \
			if [ -d "build/$${D}/incjs" ]; then \
				ocamlfind ocamlopt -w -1..66 -thread -linkpkg -package incremental -o build/$${D}/incjs/$${D} build/$${D}/incjs/$${D}.ml; \
			fi; \
			if [ -d "build/$${D}/zelus" ]; then \
				cd "build/$${D}/zelus"; \
				zeluc $${D}.zls; \
				ocamlfind ocamlc -w -1..66 -o $${D} -package zelus.gtk -linkpkg $${D}.ml $${D}_main.ml; \
				cd ../../..; \
			fi; \
			echo "running benchmarks for $${D} ....."; \
			echo "$${D}" >> result; \
			if [ "$${D}" != "chain" ]; then printf "naive & inc &" >> result; else printf "inc &" >> result; fi; \
			if [ -d "build/$${D}/rml" ]; then printf "rml &" >> result; fi; \
			if [ -d "build/$${D}/incjs" ]; then printf "incjs &" >> result; fi; \
			if [ -d "build/$${D}/zelus" ]; then printf "zelus &" >> result; fi; \
			echo "" >> result; \
			while IFS=, read col1 col2 col3; \
			do \
				printf "& $${col1} & " >> result; \
				if [ "$${D}" != "chain" ]; then \
				    exec 3>&1 4>&2; \
					foo=$$( { time build/$${D}/$${D} $${col1} $${col2} $${col3} 1>&3 2>&4; } 2>&1 | awk -F'[s.]' '/user/{print $3}'); \
					exec 3>&- 4>&-; \
					printf "$${foo}" | cut -c6- | tr -d '\n' >> result; \
					printf " & " >> result; \
				fi; \
				exec 3>&1 4>&2; \
				foo=$$( { time build/$${D}/$${D}_inc $${col1} $${col2} $${col3} 1>&3 2>&4; } 2>&1 | awk -F'[s.]' '/user/{print $3}'); \
				exec 3>&- 4>&-; \
				printf "$${foo}" | cut -c6- | tr -d '\n' >> result; \
				printf " & " >> result; \
				if [ -d "build/$${D}/rml" ]; then \
					exec 3>&1 4>&2; \
					foo=$$( { time build/$${D}/rml/$${D} $${col1} $${col2} $${col3} 1>&3 2>&4; } 2>&1 | awk -F'[s.]' '/user/{print $3}'); \
					exec 3>&- 4>&-; \
					printf "$${foo}" | cut -c6- | tr -d '\n' >> result; \
					printf " & " >> result; \
				fi; \
				if [ -d "build/$${D}/incjs" ]; then \
					exec 3>&1 4>&2; \
					foo=$$( { time build/$${D}/incjs/$${D} $${col1} $${col2} $${col3} 1>&3 2>&4; } 2>&1 | awk -F'[s.]' '/user/{print $3}'); \
					exec 3>&- 4>&-; \
					printf "$${foo}" | cut -c6- | tr -d '\n' >> result; \
					printf " & " >> result; \
				fi; \
				if [ -d "build/$${D}/zelus" ]; then \
					exec 3>&1 4>&2; \
					foo=$$( { time build/$${D}/zelus/$${D} $${col1} $${col2} $${col3} 1>&3 2>&4; } 2>&1 | awk -F'[s.]' '/user/{print $3}'); \
					exec 3>&- 4>&-; \
					printf "$${foo}" | cut -c6- | tr -d '\n' >> result; \
					printf " & " >> result; \
				fi; \
				echo "" >> result; \
			done < build/$${D}/args.csv; \
			echo "\\" >> result; \
	    fi; \
	done

