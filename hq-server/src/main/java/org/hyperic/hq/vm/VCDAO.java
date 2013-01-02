package org.hyperic.hq.vm;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SessionFactory;
import org.hyperic.hq.dao.HibernateDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class VCDAO extends HibernateDAO<MacToUUID> {
    protected final Log log = LogFactory.getLog(VCManagerImpl.class.getName());

    @Autowired
    protected VCDAO(SessionFactory f) {
        super(MacToUUID.class, f);
    }

    public void save(MacToUUID macToUUID) {
        super.save(macToUUID);
        getSession().flush();
    }
    
    @SuppressWarnings("unchecked")
    public String findByMac(String mac) throws DupMacException {
        String sql = "from MacToUUID u where u.mac = :mac ";

        List<MacToUUID> rs = getSession().createQuery(sql).setString("mac", mac).list();
        if (rs.size()==0) {
            log.error("no UUIDs are recorded for " + mac);
            return null;
        }
        if (rs.size()>1) {
            throw new DupMacException("dup4licate mac address " + mac + " in the UUID table");
        }
        
        return rs.iterator().next().getUuid();
    }
}
