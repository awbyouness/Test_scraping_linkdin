clean_name = function(data){
  library(purrr)
  result = data
  tmp = result$nom_poste %>% as.character()%>%str_to_lower()
  
  filter_name = c('tech','leader','engineer','big','lead','senior', 'chef','docteur','stagiaire',"stage",'talend',
                  'alternant')
  
  #  sum(filter_name %in% (str_split(tmp[1]," ") %>% unlist()))
  var = map(tmp,function(x) sum(filter_name %in% (str_split(x," ") %>% unlist())) ) %>% unlist()
  
  result = result[which(var==0),]
  return(result)
}
