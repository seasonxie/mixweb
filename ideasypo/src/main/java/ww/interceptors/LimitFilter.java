package ww.interceptors;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LimitFilter implements Filter {

    String sliceSizeMillisStr="";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        sliceSizeMillisStr = filterConfig.getInitParameter("");
        String windowSizeStr = filterConfig.getInitParameter("");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        if( sliceSizeMillisStr.length()>10 ) {
            filterChain.doFilter(servletRequest, servletResponse);
        } else {
            HttpServletResponse response = (HttpServletResponse) servletResponse;
            response.sendError(503,"ttttest");
        }
    }

    @Override
    public void destroy() {

    }
}
